# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest

inherit autotools eutils

DESCRIPTION="An implementation of the xmlrpc protocol in C"
HOMEPAGE="http://xmlrpc-epi.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlrpc-epi/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-64bit-fixes.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-expat.patch
	epatch "${FILESDIR}"/${P}-secondlife.patch
	epatch "${FILESDIR}"/${P}-noconflict.patch
	eautoreconf
}

src_compile() {
	econf --includedir=/usr/include/${PN} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}
