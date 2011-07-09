# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC=""

inherit ruby-fakegem

DESCRIPTION="Assigns versions to packages given a dependency graph of packages"
HOMEPAGE="https://github.com/algorist/dep_selector"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/gecode"

all_ruby_install() {
	all_fakegem_install
}
