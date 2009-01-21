# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.15.0

inherit perl-module

S=${WORKDIR}/Path-Class-URI-0.04

DESCRIPTION="No description available"
HOMEPAGE="http://search.cpan.org/search?query=Path-Class-URI&mode=dist"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/Path-Class-URI-0.04.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc sparc-fbsd x86 x86-fbsd"

DEPEND="dev-perl/URI
	dev-perl/Exporter-Lite
	dev-perl/Path-Class
	dev-lang/perl"
