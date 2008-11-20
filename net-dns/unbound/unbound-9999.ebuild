# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools subversion

DESCRIPTION="Validating, recursive, and caching DNS resolver"
HOMEPAGE="http://unbound.net"
ESVN_REPO_URI="https://unbound.net/svn/trunk"
#ESVN_REVISION="1168"

RESTRICT="nomirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-amd64 -x86"
IUSE="large-files debug doc libevent static threads"

RDEPEND="dev-libs/openssl
		libevent? ( dev-libs/libevent )
		ldns? ( >=net-dns/ldns-1.3.0 )"

DEPEND="${RDEPEND}
		doc?	(
		sys-devel/flex
		app-doc/doxygen
				)"

AC_CONFIG_SUBDIRS="ldns-src"

pkg_setup() {
	ebegin "Creating unbound group and user"
	enewgroup unbound 53
	enewuser unbound 53 -1 /etc/unbound unbound
	eend ${?}
}

src_unpack() {
	subversion_src_unpack
	eautoreconf
}

src_compile() {
	econf $(use_enable debug) \
		--with-pidfile=/var/run/unbound/unbound.pid \
		--with-conf-file=/etc/unbound/unbound.conf \
		--with-run-dir=/var/run/unbound \
		$(use_enable debug lock-checks) \
		$(use_enable debug alloc-checks) \
		$(use_enable static static-exe) \
		$(use_enable large-files largefile) \
		$(use_with libevent) \
		$(use_with threads pthreads) \
		${myconf} || die "econf failed"
	
	emake -j1 || die "emake failed to compile unbound"
}

src_install() {
	emake DESTDIR="${D}" install || die "einstall failed"
	newinitd "${FILESDIR}/unbound.initd" unbound
	dodoc doc/README doc/CREDITS doc/TODO doc/Changelog doc/FEATURES
	dodoc doc/ietf67-design-02.odp doc/ietf67-design-02.pdf
	dodoc doc/requirements.txt doc/plan
	dodoc doc/example.conf
	doman doc/libunbound.3 doc/unbound-checkconf.8
	doman doc/unbound-host.1 doc/unbound.8 doc/unbound.conf.5
	
	dodir /var/run/unbound
	keepdir /var/run/unbound
	fowners unbound:unbound /var/run/unbound
	
	dodir /var/lib/unbound
	keepdir /var/lib/unbound
	fowners unbound:unbound /var/lib/unbound
}
