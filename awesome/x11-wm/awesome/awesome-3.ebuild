# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/awesome/awesome-2.3.ebuild,v 1.1 2008/05/06 13:47:36 matsuu Exp $

EGIT_REPO_URI="git://git.naquadah.org/awesome.git"

inherit cmake-utils git

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
#SRC_URI="http://awesome.naquadah.org/download/${P}.tar.gz"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dbus doc imlib"

RDEPEND=">=x11-libs/libxcb-1.1
	>=x11-libs/xcb-util-9999
	x11-libs/cairo
	>=dev-libs/glib-2
	dev-libs/libev
	>=dev-lang/lua-5.1
	x11-libs/pango
	>=x11-libs/gtk+-2.2
	dbus? ( >=sys-apps/dbus-1 )
	imlib? ( media-libs/imlib2 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-lang/python
	app-text/asciidoc
	app-text/xmlto
	dev-util/pkgconfig
	x11-proto/xineramaproto
	x11-proto/xcb-proto
	>=dev-util/cmake-2.6
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

DOCS="AUTHORS BUGS README STYLE"

pkg_setup() {
	if ! built_with_use --missing false x11-libs/cairo xcb; then
		eerror "This package you need the useflag xcb enabled on x11-libs/cairo."
		eerror "Please emerge x11-libs/cairo again with the xcb useflag"
		eerror "enabled."
		die "Missing xcb useflag on x11-libs/cairo."
	fi
}

src_unpack() {
	git_src_unpack
	cd "${S}"
	sed -i -e '/AWESOME_CONF_PATH/s/${CMAKE_INSTALL_PREFIX}\///' awesomeConfig.cmake || die

}

src_compile() {
	mycmakeargs="${mycmakeargs}
	  $(cmake-utils_use_with imlib IMLIB2)
	  $(cmake-utils_use_with dbus DBUS)
	"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	mv "${D}"/usr/etc "${D}"/etc || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop || die

	insinto /usr/share/awesome/icons
	doins -r icons/* || die

	if use doc; then
		dohtml doc/html/* || die
	fi
}
