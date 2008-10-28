# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iwlwifi/iwlwifi-1.2.23.ebuild,v 1.1 2008/01/22 05:08:58 compnerd Exp $

inherit eutils linux-mod

MY_PV="${PV//./_}"
DESCRIPTION="Broadcom 802.11 Linux STA driver"
HOMEPAGE="http://www.broadcom.com/support/802.11/linux_sta.php"
SRC_URI="x86? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_32_${MY_PV}.tar.gz )
	amd64? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_64_${MY_PV}.tar.gz )"

LICENSE="Broadcom"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/linux-sources-2.6.22"

S="${WORKDIR}"

pkg_setup() {
	MODULE_NAMES="wl(net:${S}:${S})"
	CONFIG_CHECK="IEEE80211"
	linux-mod_pkg_setup
	if use_m; then
		BUILD_PARAMS="-C ${KV_DIR} M=${S}"
		BUILD_TARGETS=" "
	else
		die "please use a kernel >=2.6.6"
	fi
}
src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}
