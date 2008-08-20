# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
EGIT_REPO_URI="git://git.naquadah.org/awesome.git"

inherit cmake-utils eutils git

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
#SRC_URI="http://awesome.naquadah.org/download/${P}.tar.gz"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc +imlib"

RDEPEND=">=x11-libs/libxcb-1.1
	x11-libs/libX11
	>=x11-libs/xcb-util-0.2.1
	x11-libs/cairo
	>=dev-libs/glib-2
	dev-libs/libev
	>=dev-lang/lua-5.1
	x11-libs/pango
	dbus? ( >=sys-apps/dbus-1 )
	imlib? ( media-libs/imlib2 )
	!imlib? ( >=x11-libs/gtk+-2.2 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xcb-proto
	>=dev-util/cmake-2.6
	app-text/asciidoc
	app-text/xmlto
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		dev-util/luadoc
	)"

RDEPEND="${RDEPEND}
	app-shells/bash"

DOCS="AUTHORS BUGS README"

pkg_setup() {
	if ! built_with_use --missing false x11-libs/cairo xcb; then
		eerror "This package you need the useflag xcb enabled on x11-libs/cairo."
		eerror "Please emerge x11-libs/cairo again with the xcb useflag"
		eerror "enabled."
		die "Missing xcb useflag on x11-libs/cairo."
	fi
}

src_compile() {
	local myargs="all"

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=1
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=1
		$(cmake-utils_use_with imlib IMLIB2)
		$(cmake-utils_use_with dbus DBUS)"

	if use doc ; then
		mycmakeargs="${mycmakeargs} -DGENERATE_LUADOC=ON"
		myargs="${myargs} doc"
	else
		mycmakeargs="${mycmakeargs} -DGENERATE_LUADOC=OFF"
	fi
	cmake-utils_src_compile ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		dohtml -r "${WORKDIR}"/${PN}_build/doc/html/* || die
		mv "${D}"/usr/share/doc/${PN}/luadoc "${D}"/usr/share/doc/${PF}/html/luadoc || die
	fi
	rm -rf "${D}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
}