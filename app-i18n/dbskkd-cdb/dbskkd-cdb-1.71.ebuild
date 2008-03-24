# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/dbskkd-cdb/dbskkd-cdb-1.01-r1.ebuild,v 1.10 2005/05/16 03:57:39 usata Exp $

inherit eutils toolchain-funcs

MY_P="${P}dev"
DESCRIPTION="Yet another Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://www.ne.jp/asahi/bdx/info/software/jp-dbskkd.html"
SRC_URI="http://www.ne.jp/asahi/bdx/info/software/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-db/cdb"
RDEPEND="sys-process/daemontools
	sys-apps/ucspi-tcp
	|| (
		>=app-i18n/skk-jisyo-200705
		app-i18n/skk-jisyo-cdb
	)"
PROVIDE="virtual/skkserv"

S="${WORKDIR}/${MY_P}"

JISYO_FILE="/usr/share/skk/SKK-JISYO.L.cdb"

pkg_setup() {
	if has_version '>=app-i18n/skk-jisyo-200705' && ! built_with_use '>=app-i18n/skk-jisyo-200705' cdb ; then
		eerror "multiskkserv requires skk-jisyo to be built with cdb support. Please add"
		eerror "'cdb' to your USE flags, and re-emerge app-i18n/skk-jisyo."
		die "Missing cdb USE flag."
	fi
	# from READMEJP
	enewuser dbskkd -1 -1 -1 nofiles
	enewuser svlog -1 -1 -1 nofiles
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's/IP\.ADD\.RE\.SS/127.0.0.1/' \
		-e 's:/usr/local:/usr:' \
		run.example || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} \
		-DSERVERDIR="\"/usr/sbin\"" -DJISHO_FILE="\"${JISYO_FILE}\"" \
		-o dbskkd-cdb dbskkd-cdb.c /usr/$(get_libdir)/{cdb,unix,byte}.a || die
}

src_install() {
	exeinto /usr/libexec; doexe dbskkd-cdb || die
	dodoc CHANGES READMEJP

	exeinto /service/dbskkd-cdb; newexe run.example run || die
	exeinto /service/dbskkd-cdb/log; newexe run.log.example run || die
	dodir /service/dbskkd-cdb/root
	dosym "${JISYO_FILE}" /service/dbskkd-cdb/root/
	fperms +t /service/dbskkd-cdb
}
