# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/2007/03/slviewer-src-${PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/2007/03/slviewer-artwork-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
#IUSE="fmod xulrunner"
IUSE="fmod"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-2
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	dev-libs/boost
	>=net-misc/curl-7.15.4
	dev-libs/openssl
	media-libs/freetype
	media-libs/jpeg
	media-libs/libsdl
	media-libs/mesa
	media-libs/libogg
	media-libs/libvorbis
	fmod? ( x86? ( =media-libs/fmod-3.75* ) )
	=sys-libs/db-4.2*
	dev-libs/expat
	sys-libs/zlib
	>=dev-libs/xmlrpc-epi-0.51
	dev-libs/elfio
	>=media-libs/openjpeg-1.1.1
	media-fonts/kochi-substitute"
#	xulrunner? ( net-libs/xulrunner )

DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/linden"

dir="${GAMES_DATADIR}/${PN}"

src_unpack() {
	unpack ${A}

	cd "${S}"/indra

	if ! use fmod || [ "${ARCH}" != "x86" ] ; then
		epatch "${FILESDIR}"/${PN}-1.13.3.59315-no_fmod.patch
	fi

	# VWR-100
	epatch "${FILESDIR}"/${PN}-1.13.3.2-llimagej2coj_debug.patch

	epatch "${FILESDIR}"/opensecondlife-svn41.patch
	epatch "${FILESDIR}"/${PN}-1.13.3.59558-gentoo.patch

	sed -i -e "s/gcc_bin = .*$/gcc_bin = '$(tc-getCXX)'/" SConstruct || die

	# "${S}"/indra/newview/viewer_manifest.py
	touch newview/gridargs.dat
}

src_compile() {
	local mozlib

	cd "${S}"/indra

	# if use xulrunner; then
	#	mozlib="yes"
	#else
		mozlib="no"
	#fi

	CLIENT_CPPFLAGS="${CXXFLAGS}" TEMP_BUILD_DIR="/" \
		scons BUILD=release BTARGET=client DISTCC=no GRID=firstlook MOZLIB=${mozlib} || die
}

src_install() {
	cd "${S}"/indra/newview/

	insinto "${dir}"
	#doins featuretable.txt featuretable_mac.txt gpu_table.txt gridargs.dat || die
	doins featuretable.txt gpu_table.txt .txt gridargs.dat || die
	doins -r app_settings character fonts help skins res-sdl || die

	doins lsl_guide.html releasenotes.txt || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die
	newins res/ll_icon.ico secondlife.ico || die

	insinto "${dir}"/app_settings/
	doins "${S}"/scripts/messages/message_template.msg || die

	exeinto "${dir}"
	doexe linux_tools/launch_url.sh || die
	newexe linux_tools/wrapper.sh secondlife || die
	newexe ../linux_crash_logger/linux-crash-logger-*-bin* linux-crash-logger.bin || die

	exeinto "${dir}"/bin/
	newexe secondlife-*-bin do-not-directly-run-secondlife-bin || die

	keepdir "${dir}"/lib

	dosym /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf /usr/share/games/secondlife/unicode.ttf

	games_make_wrapper secondlife ./secondlife "${dir}"
	newicon res/ll_icon.ico secondlife.ico || die
	make_desktop_entry secondlife "Second Life" secondlife.ico

	dodoc releasenotes.txt
	newdoc licenses-linux.txt licenses.txt
	newdoc linux_tools/client-readme.txt README-linux.txt

	dohtml lsl_guide.html

	prepgamesdirs
}
