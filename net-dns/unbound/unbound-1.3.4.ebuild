# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils multilib

DESCRIPTION="A validating, recursive and caching DNS resolver"
HOMEPAGE="http://unbound.net/"
SRC_URI="http://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+chroot debug libevent python static threads"

RDEPEND="dev-libs/openssl
	>=net-libs/ldns-1.4
	libevent? ( dev-libs/libevent )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )"

pkg_setup() {
	enewgroup unbound
	enewuser unbound -1 -1 /etc/unbound unbound
}

src_prepare() {
	sed -i -e "s:\(withval\|thedir\)/lib:\1/$(get_libdir):" configure.ac || die
#	sed -i -e "s:\(ssldir\)/lib:\1/$(get_libdir):" acx_nlnetlabs.m4 || die
	eautoreconf
}

src_configure() {
	local myconf

	use chroot || myconf="--with-chroot-dir=\"\""

	econf \
		--with-conf-file=/etc/unbound/unbound.conf \
		--with-pidfile=/var/run/unbound.pid \
		--with-run-dir=/etc/unbound \
		--with-username=unbound \
		--with-ldns=/usr \
		$(use_enable debug) \
		$(use_enable debug lock-checks) \
		$(use_enable debug alloc-checks) \
		$(use_enable static static-exe) \
		$(use_with libevent) \
		$(use_with threads pthreads) \
		$(use_with python pyunbound) \
		$(use_with python pythonmodule) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}/unbound.initd" unbound || die "newinitd failed"
	newconfd "${FILESDIR}/unbound.confd" unbound || die "newconfd failed"

	dodoc doc/{README,CREDITS,TODO,Changelog,FEATURES} || die "dodoc failed"

	insinto /usr/share/${PN}
	insopts -m755
	doins contrib/{update-anchor.sh,update-itar.sh} || die "doins failed"
}
