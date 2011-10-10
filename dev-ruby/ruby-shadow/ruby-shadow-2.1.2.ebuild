# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-shadow/ruby-shadow-1.4.1-r1.ebuild,v 1.8 2010/09/20 19:54:53 gmsoft Exp $

EAPI="2"
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="ruby shadow bindings"
HOMEPAGE="https://github.com/apalmblad/ruby-shadow"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	case ${RUBY} in
		*ruby19)
			CFLAGS="${CFLAGS} -DRUBY19"
			;;
		*)
			;;
	esac
	emake \
		CFLAGS="${CFLAGS} -fPIC" \
		archflag="${LDFLAGS}" || die "make extension failed"
	mkdir lib || die
	cp -l shadow$(get_modname) lib/ || die
}
