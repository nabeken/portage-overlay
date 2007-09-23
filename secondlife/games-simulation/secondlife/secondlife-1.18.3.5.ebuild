# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/2007/09/slviewer-src-RC-${PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/2007/09/slviewer-artwork-RC-${PV}.zip
	http://secondlife.com/developers/opensource/downloads/2007/09/slviewer-linux-libs-RC-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug elfio fmod gstreamer"
#IUSE="debug elfio fmod gstreamer kdu mozlib"
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
	elfio? ( dev-libs/elfio )
	>=media-libs/openjpeg-1.1.1
	media-fonts/kochi-substitute
	gstreamer? ( >=media-libs/gstreamer-0.10 )
	debug? ( dev-libs/google-perftools )"
#	mozlib? ( net-libs/llmozlib-xulrunner )

DEPEND="${RDEPEND}
	>=dev-util/scons-0.97
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/linden/indra"

dir="${GAMES_DATADIR}/${PN}"

pkg_config() {
	if [ "${ARCH}" != "x86" ] ; then
		if use fmod ; then
			ewarn "fmod USE flag is only available on x86."
		fi
#		if use kdu ; then
#			ewarn "kdu USE flag is only available on x86."
#		fi
#		if use mozlib ; then
#			ewarn "mozlib USE flag is only available on x86."
#		fi
	fi
}

src_unpack() {
	# unpack font files
	unpack slviewer-linux-libs-RC-${PV}.tar.gz

#	if use kdu ; then
#		find linden/libraries -type f -a ! -name '*kdu*' | xargs rm -f || die
#	else
		rm -rf linden/libraries
#	fi

#	if ! use mozlib ; then
		rm -rf linden/indra/newview/app_settings
#	fi

	unpack slviewer-src-RC-${PV}.tar.gz
	unpack slviewer-artwork-RC-${PV}.zip

	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${PN}-1.17.2.0-size_t.patch

	sed -i -e "s|gcc_bin = .*$|gcc_bin = '$(tc-getCXX)'|" "${S}"/SConstruct || die

	# "${S}"/newview/viewer_manifest.py
	touch "${S}"/newview/gridargs.dat
}

src_compile() {
	local myarch
	local myopts="BUILD=release BTARGET=client DISTCC=no"

	if use debug ; then
		myopts="${myopts} BUILD=debug"
	else
		myopts="${myopts} BUILD=release"
	fi

	if use elfio ; then
		myopts="${myopts} ELFIO=yes"
	else
		myopts="${myopts} ELFIO=no"
	fi

	if use gstreamer ; then
		myopts="${myopts} GSTREAMER=yes"
	else
		myopts="${myopts} GSTREAMER=no"
	fi

	case ${ARCH} in
		x86)
			myopts="${myopts} ARCH=i686"
			;;
		amd64)
			myopts="${myopts} ARCH=x86_64"
			;;
		ppc|ppc64)
			myopts="${myopts} ARCH=powerpc"
			;;
		*)
			myopts="${myopts} ARCH=i686"
			;;
	esac

	if [ "${ARCH}" == "x86" ] ; then
		if use fmod; then
			myopts="${myopts} FMOD=yes OPENSOURCE=no"
		else
			myopts="${myopts} FMOD=no OPENSOURCE=yes"
		fi

#		if use mozlib ; then
#			myopts="${myopts} MOZLIB=yes STANDALONE=no"
#		else
			myopts="${myopts} MOZLIB=no STANDALONE=yes"
#		fi
	else
		myopts="${myopts} FMOD=no MOZLIB=no STANDALONE=yes OPENSOURCE=yes"
	fi

	CLIENT_CPPFLAGS="${CXXFLAGS}" TEMP_BUILD_DIR= scons ${myopts} || die
}

src_install() {
	cd "${S}"/newview/

	insinto "${dir}"
	doins gpu_table.txt gridargs.dat secondlife-i686.supp featuretable_linux.txt || die
	doins -r app_settings character fonts skins res-sdl || die

	doins lsl_guide.html releasenotes.txt || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die
	newins res/ll_icon.ico secondlife.ico || die

	insinto "${dir}"/app_settings/
	doins "${WORKDIR}"/linden/scripts/messages/message_template.msg || die
	doins "${WORKDIR}"/linden/etc/message.xml || die

	exeinto "${dir}"
	doexe linux_tools/launch_url.sh || die
	newexe linux_tools/wrapper.sh secondlife || die
	newexe ../linux_crash_logger/linux-crash-logger-*-bin* linux-crash-logger.bin || die

	exeinto "${dir}"/bin/
	newexe secondlife-*-bin do-not-directly-run-secondlife-bin || die

	exeinto "${dir}"/lib
	doexe ../lib_release_client/*-linux/lib* || die

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
