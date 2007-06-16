# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Fast, mutli-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"
SRC_URI="http://google-perftools.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

DEPEND="sys-libs/libunwind"

src_compile() {
	econf || die
	# parallel borks
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	rm -rf "${D}"/usr/share/doc/${P}
	
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml doc/*
}
