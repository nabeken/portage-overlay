# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit git

EGIT_REPO_URI="git://git.glacicle.com/awesome/eminent"

DESCRIPTION="Eminent dynamic tagging lybrary for the awesome window manager"
HOMEPAGE="http://git.glacicle.com/?p=awesome/wicked.git;a=summary"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua"

src_install()
{
	insinto /usr/share/awesome/lib
	doins eminent.lua
	doman eminent.7.gz
}
