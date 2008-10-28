# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games toolchain-funcs

MY_P="micropolis-activity"
DESCRIPTION="Micropolis"
HOMEPAGE="http://www.donhopkins.com/home/micropolis/"
SRC_URI="http://www.donhopkins.com/home/micropolis/${MY_P}-source.tgz
	http://rmdir.de/~michael/${PN}_mac-osx.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/bison"

S="${WORKDIR}/${MY_P}"

dir="${GAMES_DATADIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${DISTDIR}"/${PN}_mac-osx.patch
	sed -i -e "s:-O3:${CFLAGS}:" \
		src/tclx/config.mk src/{sim,tcl,tk}/makefile || die
}

src_compile() {
	cd src
	emake CC="$(tc-getCC)" || die
}

src_install() {
	exeinto "${dir}"
	doexe Micropolis || die
	exeinto "${dir}/res"
	doexe src/sim/sim || die
	insinto "${dir}"
	doins Micropolis.png || die
	doins -r activity cities images manual res || die

	games_make_wrapper Micropolis res/sim "${dir}"
	doicon Micropolis.png
	make_desktop_entry Micropolis "Micropolis" Micropolis.png
	
}
