# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Configuration management tool"
HOMEPAGE="http://wiki.opscode.com/display/chef"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "~app-admin/chef-${PV}
	>=dev-ruby/amqp-0.6.7
	>=dev-ruby/bunny-0.6.0
	>=dev-ruby/em-http-request-0.2.11
	>=dev-ruby/eventmachine-0.12.10
	>=dev-ruby/fast_xs-0.7.3
	>=dev-ruby/highline-1.6.1
	>=dev-ruby/mixlib-log-1.2.0
	>=dev-ruby/yajl-ruby-0.7.7
	>=dev-ruby/mixlib-log-1.2.0"

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

each_ruby_install() {
	each_fakegem_install
	#ruby_fakegem_doins -r solr
}

all_ruby_install() {
	all_fakegem_install

	doinitd "${FILESDIR}/initd/chef-expander"
	doconfd "${FILESDIR}/confd/chef-expander"

	keepdir /etc/chef /var/lib/chef /var/log/chef /var/run/chef

	#insinto /etc/chef
	#doins "${FILESDIR}/solr.rb"

	fowners chef:chef /etc/chef/
	fowners chef:chef /var/{lib,log,run}/chef
}
