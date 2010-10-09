# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc doc/*.txt"

inherit ruby-fakegem

DESCRIPTION="Termtter is a terminal based twitter client"
HOMEPAGE="http://termtter.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/json-1.1.3
	>=dev-ruby/highline-1.5
	>=dev-ruby/notify-0.2.1
	>=dev-ruby/rubytter-1.4
	>=dev-ruby/termcolor-1"

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_doins VERSION || die
}
