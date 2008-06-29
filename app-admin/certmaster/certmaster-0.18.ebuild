# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Certmaster is a set of tools and a library for easily distributing SSL certificates"
HOMEPAGE="https://fedorahosted.org/certmaster"
SRC_URI="http://people.fedoraproject.org/~mdehaan/files/certmaster/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}
	dev-python/pyopenssl"

src_unpack() {
	distutils_src_unpack

	epatch "${FILESDIR}"/0001-Add-default-value-of-cert_extension-in-certmaster.patch
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install

	if use doc; then
		doman "${S}"/docs/*.gz || die
	fi
}
