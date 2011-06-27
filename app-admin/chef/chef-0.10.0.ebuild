# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Chef is a systems integration framework"
HOMEPAGE="http://wiki.opscode.com/display/chef"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/bunny-0.6.0
	dev-ruby/erubis
	dev-ruby/highline
	>=dev-ruby/json-1.4.4
	>=dev-ruby/mixlib-authentication-1.1.0
	>=dev-ruby/mixlib-cli-1.1.0
	>=dev-ruby/mixlib-config-1.1.0
	>=dev-ruby/mixlib-log-1.3.0
	dev-ruby/moneta
	>=dev-ruby/ohai-0.5.6
	>=dev-ruby/rest-client-1.0.4
	<dev-ruby/rest-client-1.7.0
	dev-ruby/ruby-shadow
	dev-ruby/uuidtools"

#all_ruby_prepare() {
#	epatch "${FILESDIR}"/${PN}-0.9.12-package-reinstall.patch
#}

all_ruby_install() {
	all_fakegem_install

	keepdir /etc/chef /var/lib/chef /var/log/chef /var/run/chef

	doinitd "${FILESDIR}/initd/chef-client"
	doconfd "${FILESDIR}/confd/chef-client"

	insinto /etc/chef
	doins "${FILESDIR}/client.rb"
	doins "${FILESDIR}/solo.rb"
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/client.rb before starting the service with"
	elog "/etc/init.d/chef-client start"
	elog
}
