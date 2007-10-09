# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git toolchain-funcs

DESCRIPTION="awesome is a window manager initialy based on a dwm code rewriting"
HOMEPAGE="http://awesome.naquadah.org/"
#SRC_URI="http://awesome.naquadah.org/download/${P}.tar.gz"
EGIT_REPO_URI="git://git.naquadah.org/awesome.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/confuse
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xineramaproto"

src_unpack() {
	git_src_unpack
	cd "${S}"
	sed -i \
		-e "/^CFLAGS/s/=.*-O3/= ${CFLAGS}/" \
		-e "/^LDFLAGS/s/-ggdb3/${LDFLAGS}/" \
		-e "/^CC/s/cc/$(tc-getCC)/" \
		-e "s:/usr/lib:/usr/$(get_libdir):" \
		-e "s:/usr/local:/usr:" \
		config.mk || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	exeinto /etc/X11/Sessions; newexe "${FILESDIR}"/${PN}-session ${PN}
	insinto /usr/share/xsessions; doins "${FILESDIR}"/${PN}.desktop

	dodoc AUTHORS README awesomerc
}

