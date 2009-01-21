# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.15.0

inherit perl-module

S=${WORKDIR}/File-Find-Rule-Filesys-Virtual-1.22

DESCRIPTION="No description available"
HOMEPAGE="http://search.cpan.org/search?query=File-Find-Rule-Filesys-Virtual&mode=dist"
SRC_URI="mirror://cpan/authors/id/R/RC/RCLAMP/File-Find-Rule-Filesys-Virtual-1.22.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc sparc-fbsd x86 x86-fbsd"

DEPEND=">=dev-perl/File-Find-Rule-0.30
	perl-gcpan/Filesys-Virtual
	dev-lang/perl"
