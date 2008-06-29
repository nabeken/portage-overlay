# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Func is Fedora Unified Network Controller"
HOMEPAGE="https://fedorahosted.org/func"
SRC_URI="http://people.fedoraproject.org/~mdehaan/files/func/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc ipv6 puppet"

RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}
	dev-python/pyopenssl"

src_unpack() {
	distutils_src_unpack

	if use ipv6; then
	    epatch "${FILESDIR}"/0001-Add-IPv6-support-using-socket.getaddrinfo.patch
	fi

	if use puppet; then
	    epatch "${FILESDIR}"/0002-Using-config.cert_extension-instead-of-hardcoded-cer.patch
	fi
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
