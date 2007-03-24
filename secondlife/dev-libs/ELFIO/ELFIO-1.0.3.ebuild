# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ELF (Executable and Linkable Format) reader and producer implemented as a C++ library."
HOMEPAGE="http://elfio.sourceforge.net/"
SRC_URI="mirror://sourceforge/elfio/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~mips ~sparc ~x86"
IUSE=""

src_compile() {
	append-flags -fPIC
	econf || die "econf failed"
	emake || die "emake failed"

	# for secondlife
	cd ELFIO && $(tc-getCC) -shared *.o -o libelfio.so || die
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dolib.so ELFIO/libelfio.so || die

	dodoc AUTHORS NEWS README
}
