# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit ruby

DESCRIPTION="A cross-platform Ruby library for retrieving facts from operating systems"
LICENSE="GPL-2"
HOMEPAGE="http://reductivelabs.com/projects/facter/index.html"
SRC_URI="http://reductivelabs.com/downloads/${PN}/${P}.tgz"

SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

USE_RUBY="ruby18"

src_compile() {
	DESTDIR=${D} ruby_econf || die
	DESTDIR=${D} ruby_emake "$@" || die
}


src_install() {
	DESTDIR=${D} ruby_einstall "$@" || die
	DESTDIR=${D} erubydoc
}
