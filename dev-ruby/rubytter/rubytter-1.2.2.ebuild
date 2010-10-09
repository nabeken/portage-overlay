# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

DESCRIPTION="Rubytter is a simple twitter library"
HOMEPAGE="http://wiki.github.com/jugyo/rubytter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/json-1.1.3
	>=dev-ruby/oauth-0.3.6"
RDEPEND="${DEPEND}"

USE_RUBY="ruby18 ruby19"
