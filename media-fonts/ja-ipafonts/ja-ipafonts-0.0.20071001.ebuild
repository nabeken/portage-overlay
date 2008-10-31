# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ja-ipafonts/ja-ipafonts-0.0.20040715.ebuild,v 1.10 2007/07/02 02:35:19 peper Exp $

inherit font

MY_P="IPAfont00201"
DESCRIPTION="Japanese TrueType fonts developed by IPA (Information-technology Promotion Agency, Japan)"
HOMEPAGE="http://ossipedia.ipa.go.jp/ipafont/"
SRC_URI="http://ossipedia.ipa.go.jp/ipafont/${MY_P}.php/${MY_P}.zip"
LICENSE="IPAfont"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_SUFFIX="ttf"
#FONT_S="${S}"

DOCS="Readme*.txt"

# Only installs fonts
RESTRICT="mirror strip binchecks"
