# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib pam

MY_P="${P/_/-}"
DESCRIPTION="New PAM module for MIT Kerberos V"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-krb5/"
SRC_URI="http://archives.eyrie.org/software/kerberos/${MY_P}.tar.gz"

LICENSE="BSD GPL-2 as-is"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/krb5
	sys-libs/pam"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --libdir=/$(get_libdir) || die
	emake || die
}

src_install() {
	dopammod pam_krb5.so || die
	doman pam_krb5.5
	dodoc CHANGES* NEWS README TODO
}
