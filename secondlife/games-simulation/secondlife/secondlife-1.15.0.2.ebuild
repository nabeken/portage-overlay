# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/2007/04/slviewer-src-${PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/2007/04/slviewer-artwork-${PV}.zip
	http://secondlife.com/developers/opensource/downloads/2007/04/slviewer-linux-libs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="fmod"
#IUSE="fmod llmozlib"
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
#	llmozlib? ( net-libs/llmozlib-xulrunner )

DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/linden/indra"

dir="${GAMES_DATADIR}/${PN}"

src_unpack() {
	# unpack font files
	unpack slviewer-linux-libs-${PV}.tar.gz
	rm -rf linden/libraries
	rm -rf linden/indra/newview/app_settings

	unpack slviewer-src-${PV}.tar.gz
	unpack slviewer-artwork-${PV}.zip

	cd "${S}"

	# opensecondlife.com
	epatch "${FILESDIR}"/opensecondlife-svn41.patch

	epatch "${FILESDIR}"/${P}-mozlib.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch

	cd "${S}"/llwindow/
	epatch "${FILESDIR}"/llwindowssdl_16bit_depth.patch

	sed -i -e "s|gcc_bin = .*$|gcc_bin = '$(tc-getCXX)'|" "${S}"/SConstruct || die

	# "${S}"/newview/viewer_manifest.py
	touch "${S}"/newview/gridargs.dat
}

src_compile() {
	local myopts="BUILD=release BTARGET=client DISTCC=no"

	# if use llmozlib ; then
	# 	myopts="${myopts} MOZLIB=yes"
	# else
		myopts="${myopts} MOZLIB=no"
	# fi

	if use fmod && [ "${ARCH}" == "x86" ] ; then
		myopts="${myopts} FMOD=yes"
	else
		myopts="${myopts} FMOD=no"
	fi

	CLIENT_CPPFLAGS="${CXXFLAGS}" TEMP_BUILD_DIR=/ scons ${myopts} || die
}

src_install() {
	cd "${S}"/newview/

	insinto "${dir}"
	doins featuretable.txt gpu_table.txt gridargs.dat || die
	doins -r app_settings character fonts skins res-sdl || die

	doins lsl_guide.html releasenotes.txt || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die
	newins res/ll_icon.ico secondlife.ico || die

	insinto "${dir}"/app_settings/
	doins "${WORKDIR}"/linden/scripts/messages/message_template.msg || die

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
