# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion mozextension multilib

ESVN_REPO_URI="http://google-gears.googlecode.com/svn/trunk/gears"

DESCRIPTION="Google Gears"
HOMEPAGE="http://code.google.com/p/google-gears/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="www-client/mozilla-firefox
	dev-util/pkgconfig"

S="${WORKDIR}/gears"

MOZILLA_FIVE_HOME="/usr/$(get_libdir)/mozilla-firefox"

src_unpack() {
	subversion_src_unpack

	cd "${S}"

	local myarch="i386"

	if ! use x86 ; then
		myarch="$(uname -m)"
	fi

	sed -i \
		-e "/ARCH = /s:i386:${myarch}:" \
		-e "s:gcc:$(tc-getCC):" \
		-e "s:g++:$(tc-getCXX):" \
		-e "/^GECKO_SDK = /s:=.*:= ${MOZILLA_FIVE_HOME}:" \
		-e "/^FF_CPPFLAGS = /s:$: $(pkg-config firefox-xpcom --cflags) -I${MOZILLA_FIVE_HOME}/include/dom -I${MOZILLA_FIVE_HOME}/include/necko:" \
		-e "/^FF_LIBS = /s:-lxpcomglue_s:$(pkg-config firefox-xpcom --libs):" \
		-e "s:\(\$(GECKO_SDK)\)/\(bin\|lib\):\1:" \
		-e "/^COMPILE_FLAGS_opt = /s:-O2:${CFLAGS}:" \
		-e "/^COMPILE_FLAGS = /s:-Werror::" \
		tools/{config,rules}.mk || die

	sed -i -e "/OnListenerEvent/s:<int>:<long>:" \
		localserver/firefox/async_task_ff.cc || die

	if ! use x86 ; then
		sed -i -e "s/x86/${myarch}/g" base/firefox/install.rdf.m4 || die
	fi

	if ! use debug ; then
		sed -i -e "/^MODE = /s|dbg|opt|" tools/config.mk || die
	fi
}

src_install() {
	xpi_install "${S}"/bin-*/installers/gears-*/

	dohtml -r sdk
}
