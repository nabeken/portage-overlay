# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_REPO_URI="http://action-coding.googlecode.com/svn/trunk"

DESCRIPTION="Ruby + Processing"
HOMEPAGE="http://code.google.com/p/action-coding/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# java-overlay
RDEPEND=">=dev-java/jruby-1.1
	media-gfx/processing"

OPTDIR="/opt/${PN}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	sed -i -e '/^p5home/s|: .*|: /opt/processing|' config.yaml || die
}

src_install() {
	insinto "${OPTDIR}"
	cp -pPR * "${D}${OPTDIR}" || die
	
	make_wrapper ${PN} ./run.command "${OPTDIR}" || die
}
