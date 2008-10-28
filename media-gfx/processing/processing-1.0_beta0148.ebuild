# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/-*_beta/-}"
DESCRIPTION="an open source programming language and environment for people who want to program images, animation, and sound"
HOMEPAGE="http://processing.org/"
SRC_URI="http://processing.org/download/${MY_P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jdk-1.5
	x11-misc/xdg-utils
	amd64? (
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)"

S="${WORKDIR}/${MY_P}"

OPTDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^browser.linux/s|mozilla|xdg-open|' lib/preferences.txt || die
}

src_install() {
	insinto "${OPTDIR}"
	cp -pPR * "${D}${OPTDIR}" || die
	make_wrapper ${PN} ./processing "${OPTDIR}" || die

	dodoc revisions.txt
	dohtml -r reference/*
	dosym /usr/share/doc/${PF}/html "${OPTDIR}"/reference
}
