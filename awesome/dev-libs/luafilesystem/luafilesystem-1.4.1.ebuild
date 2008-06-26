# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib toolchain-funcs

DESCRIPTION="a Lua library developed to complement the set of functions related to file systems offered by the standard Lua distribution"
HOMEPAGE="http://www.keplerproject.org/luafilesystem/"
SRC_URI="http://luaforge.net/frs/download.php/3345/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/lua-5.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|-O2|${CFLAGS}|" \
		-e "s|gcc|$(tc-getCC)|" \
		config || die
}

src_install() {
	emake PREFIX="${D}usr" install || die
	dodoc README
}
