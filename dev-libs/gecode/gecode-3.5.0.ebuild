# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit libtool eutils autotools

DESCRIPTION="A toolkit for developing constraint-based systems and applications"
HOMEPAGE="http://www.gecode.org/"
SRC_URI="http://www.gecode.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_configure() {
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc changelog.in
}
