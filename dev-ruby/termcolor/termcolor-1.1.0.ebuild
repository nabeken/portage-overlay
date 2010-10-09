# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

DESCRIPTION="a library for ANSI color formatting like HTML for output in terminal"
HOMEPAGE="http://termcolor.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/highline-1.5.0"
RDEPEND="${DEPEND}"

USE_RUBY="ruby18"
