# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git perl-app

DESCRIPTION="Pure perl, Web-based and Pluggable Media Center Application"
HOMEPAGE="http://remediecode.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/miyagawa/remedie.git"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Cache-Cache
	dev-perl/Class-Accessor
	dev-perl/DateTime
	dev-perl/DateTime-Format-ISO8601
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTime-TimeZone
	virtual/perl-Digest-MD5
	dev-perl/Feed-Find
	dev-perl/File-Find-Rule
	virtual/perl-File-Temp
	dev-perl/HTML-Parser
	dev-perl/HTML-Scrubber
	dev-perl/HTML-Tagset
	dev-perl/HTML-Tree
	dev-perl/ImageInfo
	dev-perl/JSON-XS
	dev-perl/libwww-perl
	dev-perl/Log-Log4perl
	dev-perl/log-dispatch
	dev-perl/MIME-Types
	dev-perl/Moose
	dev-perl/Path-Class
	virtual/perl-PodParser
	dev-perl/String-ShellQuote
	dev-perl/TimeDate
	dev-perl/Template-Toolkit
	dev-perl/UNIVERSAL-require
	dev-perl/URI
	dev-perl/URI-Fetch
	dev-perl/XML-Atom
	dev-perl/XML-LibXML
	dev-perl/XML-RSS
	dev-perl/XML-Feed
	dev-perl/yaml
	dev-perl/YAML-Syck"
#	dev-perl/File-ShareDir

DEPEND="${RDEPEND}
	virtual/perl-Test-Simple"

RDEPEND="${RDEPEND}
	dev-perl/DBD-SQLite
	!dev-perl/Plagger
	!dev-gcpan/Plagger"

GCPAN_MODULES="
	Filesys-Virtual
	Filesys-Virtual-Plain
	File-Find-Rule-Filesys-Virtual
	FindBin-libs
	HTML-ResolveLink
	HTML-Selector-XPath
	HTML-TreeBuilder-XPath
	HTTP-Engine
	Module-Install
	Module-Install-AuthorTests
	MooseX-ClassAttribute
	MooseX-ConfigFromFile
	MooseX-Getopt
	MooseX-Types-Path-Class
	Path-Class-URI
	Rose-DB
	Rose-DB-Object
	String-CamelCase
	Text-Tags
	Web-Scraper
	XML-LibXML-Simple
	XML-RSS-LibXML
	XML-OPML-LibXML"
#	DateTime-Format-Japanese

pkg_setup() {
	local req_modules
	for module in ${GCPAN_MODULES}; do
		if ! has_version "dev-perl/$module" && ! has_version "perl-gcpan/${module}"; then
			req_modules="${req_modules} ${module}"
		fi
	done
	if [ -n "${req_modules}" ]; then
		eerror "Please install following modules by g-cpan"
		eerror
		eerror "g-cpan -i ${req_modules//-/::}"
		die
	fi
}

src_unpack() {
	git_src_unpack
}

src_install() {
	perl-module_src_install

	dobin bin/remedie-server.pl

	insinto /var/lib/remedie
	doins -r root

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	dodoc HACKING Changes README.mkdn
}
