# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC=""

inherit ruby-fakegem

DESCRIPTION="A C extensions for escaping text."
HOMEPAGE="http://rubyforge.org/projects/fast-xs/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die "extconf.rb failed"
	${RUBY} -Cext/${PN}_extra extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/${PN} \
		CFLAGS="${CFLAGS} -fPIC" \
		archflag="${LDFLAGS}" || die "make extension failed"
	cp -l ext/${PN}/${PN}$(get_modname) lib/ || die

	emake -Cext/${PN}_extra \
		CFLAGS="${CFLAGS} -fPIC" \
		archflag="${LDFLAGS}" || die "make extension failed"
	cp -l ext/${PN}_extra/${PN}_extra$(get_modname) lib/ || die
}
