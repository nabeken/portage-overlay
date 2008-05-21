# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/awesome/awesome-2.3.ebuild,v 1.1 2008/05/06 13:47:36 matsuu Exp $

EGIT_REPO_URI="git://git.naquadah.org/awesome.git"
EGIT_BRANCH="${P}"
EGIT_BOOTSTRAP="autogen.sh"

inherit toolchain-funcs eutils git

DESCRIPTION="awesome is a window manager initialy based on a dwm code rewriting"
HOMEPAGE="http://awesome.naquadah.org/"
#SRC_URI="http://awesome.naquadah.org/download/${P}.tar.gz"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc imlib"

RDEPEND="x11-libs/libxcb
	>=x11-libs/xcb-util-9999
	x11-libs/cairo
	>=dev-libs/glib-2
	>=sys-apps/dbus-1
	>=dev-lang/lua-5.1
	x11-libs/pango
	imlib? ( media-libs/imlib2 )
	!imlib? ( >=x11-libs/gtk+-2.2 )"
#	x11-libs/libXrandr
#	x11-libs/libXinerama

DEPEND="${RDEPEND}
	dev-lang/python
	app-text/asciidoc
	app-text/xmlto
	dev-util/pkgconfig
	x11-proto/xineramaproto
	x11-proto/xcb-proto
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

pkg_setup() {
	if ! built_with_use --missing false x11-libs/cairo xcb; then
		eerror "This package you need the useflag xcb enabled on x11-libs/cairo."
		eerror "Please emerge x11-libs/cairo again with the xcb useflag"
		eerror "enabled."
		die "Missing xcb useflag on x11-libs/cairo."
	fi
}

src_compile() {
	econf \
		$(use_with imlib imlib2) \
		--docdir="/usr/share/doc/${PF}" || die
	emake || die

	if use doc; then
		emake doc || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	insinto /usr/share/awesome/icons
	doins -r icons/*

	if use doc; then
		dohtml doc/html/*
	fi

	prepalldocs
}
