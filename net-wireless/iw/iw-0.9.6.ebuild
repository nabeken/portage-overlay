# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="nl80211-based CLI configuration utility for wireless devices"
HOMEPAGE="http://wireless.kernel.org/en/users/Documentation/iw"
SRC_URI="http://wireless.kernel.org/download/${PN}/${P}.tar.bz2"

LICENSE="iw"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libnl-1.0_pre8"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^CC/s:gcc:$(tc-getCC):" \
		-e "/^CFLAGS/s:-O2 -g:${CFLAGS}:" \
		Makefile || die
	sed -i \
		-e "/^\.B ip/s:ip:iw:" \
		iw.8 || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
