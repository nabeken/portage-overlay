# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

MY_PV="Branch_1-19-1-Viewer-r84244"
MY_DATE="2008/04"
DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-src-${MY_PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-artwork-${MY_PV}.zip
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-linux-libs-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug elfio fmod gstreamer kdu llmozlib2"
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
	>=dev-libs/xmlrpc-epi-0.51-r1
	elfio? ( dev-libs/elfio )
	>=media-libs/openjpeg-1.1.1
	media-fonts/kochi-substitute
	>=net-dns/c-ares-1.5
	x11-libs/pango
	gstreamer? ( >=media-libs/gst-plugins-base-0.10 )
	debug? ( dev-libs/google-perftools )"
#	llmozlib2? ( net-libs/llmozlib2 )

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
		if use kdu ; then
			ewarn "kdu USE flag is only available on x86."
		fi
		if use llmozlib2 ; then
			ewarn "llmozlib2 USE flag is only available on x86."
		fi
	fi
}

src_unpack() {
	# unpack font files
	unpack slviewer-linux-libs-${MY_PV}.tar.gz

	if use kdu ; then
		find linden/libraries -type f -a ! -name '*kdu*' | xargs rm -f || die
	else
		rm -rf linden/libraries
	fi

	if ! use llmozlib2 ; then
		rm -rf linden/indra/newview/app_settings
	fi

	unpack slviewer-src-${MY_PV}.tar.gz
	unpack slviewer-artwork-${MY_PV}.zip

	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/VWR-3480.patch

	sed -i \
		-e "s|gcc_bin = .*$|gcc_bin = '$(tc-getCXX)'|" \
		-e "/_cflags =/s|-O2|${CFLAGS}|" \
		-e "/_cxxflags =/s|-O2|${CXXFLAGS}|" \
		"${S}"/SConstruct || die

	# "${S}"/newview/viewer_manifest.py
	touch "${S}"/newview/gridargs.dat
}

src_compile() {
	local myarch
	local myopts="BUILD=release BTARGET=client DISTCC=no STANDALONE=yes"

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
		if use fmod ; then
			myopts="${myopts} FMOD=yes"
		else
			myopts="${myopts} FMOD=no"
		fi

		if use kdu ; then
			myopts="${myopts} OPENSOURCE=no"
		else
			myopts="${myopts} OPENSOURCE=yes"
		fi

		if use llmozlib2 ; then
			myopts="${myopts} MOZLIB2=yes"
		else
			myopts="${myopts} MOZLIB2=no"
		fi
	else
		myopts="${myopts} FMOD=no MOZLIB2=no OPENSOURCE=yes"
	fi

	TEMP_BUILD_DIR= scons ${myopts} || die
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
	doexe ../lib_*_client/*-linux/lib* || die

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
