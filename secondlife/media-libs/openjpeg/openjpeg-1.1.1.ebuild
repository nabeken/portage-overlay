# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="An open-source JPEG 2000 codec written in C"
HOMEPAGE="http://www.openjpeg.org/"
SRC_URI="http://www.openjpeg.org/openjpeg_v${PV//./_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

S="${WORKDIR}/OpenJPEG"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/OPJ_limit_tags_for_decode_UPDATED.patch
}

src_compile() {
	append-flags -fPIC
	emake CC="$(tc-getCC)" COMPILERFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dodir /usr/$(get_libdir)
	emake INSTALLDIR="${D}usr/$(get_libdir)" install || die "install failed"

	insinto /usr/include
	doins libopenjpeg/openjpeg.h

	dodoc ChangeLog README.linux
}
