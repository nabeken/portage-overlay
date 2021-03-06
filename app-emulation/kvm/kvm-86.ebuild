# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/kvm/kvm-85-r2.ebuild,v 1.1 2009/05/14 14:40:02 dang Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs linux-info

MY_PN="qemu-${PN}-devel"
MY_P="${MY_PN}-${PV}"

SRC_URI="mirror://sourceforge/kvm/${MY_P}.tar.gz"

DESCRIPTION="Kernel-based Virtual Machine userland tools"
HOMEPAGE="http://www.linux-kvm.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
# Add bios back when it builds again
IUSE="alsa bluetooth esd gnutls havekernel +modules ncurses pulseaudio +sdl vde"
RESTRICT="test"

RDEPEND="sys-libs/zlib
	sys-apps/pciutils
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )
	gnutls? ( net-libs/gnutls )
	ncurses? ( sys-libs/ncurses )
	sdl? ( >=media-libs/libsdl-1.2.11[X] )
	vde? ( net-misc/vde )
	bluetooth? ( net-wireless/bluez )
	modules? ( =app-emulation/kvm-kmod-${PV} )"

#    bios? (
#        sys-devel/dev86
#        dev-lang/perl
#        sys-power/iasl
#    )
DEPEND="${RDEPEND}
	gnutls? ( dev-util/pkgconfig )
	app-text/texi2html"

QA_TEXTRELS="usr/bin/kvm"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use havekernel && use modules ; then
		ewarn "You have the 'havekernel' and 'modules' use flags enabled."
		ewarn "'havekernel' trumps 'modules'; the kvm modules will not"
		ewarn "be built.  You must ensure you have a compatible kernel"
		ewarn "with the kvm modules on your own"
	elif use havekernel ; then
		ewarn "You have the 'havekernel' use flag set.  This means you"
		ewarn "must ensure you have a compatible kernel on your own."
	elif use modules ; then
		:;
	elif kernel_is lt 2 6 25; then
		eerror "This version of KVM requres a host kernel of 2.6.25 or higher."
		eerror "Either upgrade your kernel, or enable the 'modules' USE flag."
		die "kvm version not compatible"
	elif ! linux_chkconfig_present KVM; then
		eerror "Please enable KVM support in your kernel, found at:"
		eerror
		eerror "  Virtualization"
		eerror "    Kernel-based Virtual Machine (KVM) support"
		eerror
		eerror "or enable the 'modules' USE flag."
		die "KVM support not detected!"
	fi

	enewgroup kvm
}

src_prepare() {
	cd "${S}"
	# prevent docs to get automatically installed
	sed -i '/$(DESTDIR)$(docdir)/d' qemu/Makefile
	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		qemu/Makefile qemu/Makefile.target
	[[ -x /sbin/paxctl ]] && \
		sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' \
			qemu/Makefile.target

	# Fix docs manually
	sed -i -e 's/QEMU/KVM/g;s/qemu/kvm/g;s/Qemu/Kvm/g;s/kvm-options.texi/qemu-options.texi/' \
		qemu/qemu-doc.texi qemu/qemu-img.texi qemu/qemu-nbd.texi
}

src_configure() {
	local mycc conf_opts audio_opts

	audio_opts="oss"
	use gnutls || conf_opts="$conf_opts --disable-vnc-tls"
	use ncurses || conf_opts="$conf_opts --disable-curses"
	use sdl || conf_opts="$conf_opts --disable-gfx-check --disable-sdl"
	use vde || conf_opts="$conf_opts --disable-vde"
	use bluetooth || conf_opts="$conf_opts --disable-bluez"
	use alsa && audio_opts="alsa $audio_opts"
	use esd && audio_opts="esd $audio_opts"
	use pulseaudio && audio_opts="pa $audio_opts"
	use sdl && audio_opts="sdl $audio_opts"
	conf_opts="$conf_opts --prefix=/usr"
	conf_opts="$conf_opts --disable-strip"
	if has_multilib_profile && [[ "${DEFAULT_ABI}" == "x86" ]] ; then
		conf_opts="$conf_opts --arch=i686"
	fi

	# set up asm symlink; not done now there's no kernel source
	cd kernel/include && ln -sf asm-x86 asm && cd ../..

	./configure ${conf_opts} --audio-drv-list="$audio_opts" || die "econf failed"
}

src_compile() {
	emake libkvm || die "emake libkvm failed"

	mycc=$(cat qemu/config-host.mak | egrep "^CC=" | cut -d "=" -f 2)

	filter-flags -fpie -fstack-protector

	# If using gentoo's compiler set the SPEC to non-hardened
	if [ ! -z ${GCC_SPECS} -a -f ${GCC_SPECS} ]; then
		local myccver=$(${mycc} -dumpversion)
		local gccver=$($(tc-getBUILD_CC) -dumpversion)

		#Is this a SPEC for the right compiler version?
		myspec="${GCC_SPECS/${gccver}/${myccver}}"
		if [ "${myspec}" == "${GCC_SPECS}" ]; then
			shopt -s extglob
			GCC_SPECS="${GCC_SPECS/%hardened*specs/vanilla.specs}"
			shopt -u extglob
		else
			unset GCC_SPECS
		fi
	fi

#    if use bios; then
#        emake bios || die "emake bios failed"
#        emake vgabios || die "emake vgabios failed"
#    fi

	emake qemu || die "emake qemu failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	exeinto /usr/bin/
	doexe "${S}/kvm_stat"

	mv "${D}"/usr/share/man/man1/qemu.1 "${D}"/usr/share/man/man1/kvm.1
	mv "${D}"/usr/share/man/man1/qemu-img.1 "${D}"/usr/share/man/man1/kvm-img.1
	mv "${D}"/usr/share/man/man8/qemu-nbd.8 "${D}"/usr/share/man/man8/kvm-nbd.8
	mv "${D}"/usr/bin/qemu-img "${D}"/usr/bin/kvm-img
	mv "${D}"/usr/bin/qemu-nbd "${D}"/usr/bin/kvm-nbd

	insinto /etc/udev/rules.d/
	doins scripts/65-kvm.rules

	insinto /etc/kvm/
	insopts -m0755
	newins scripts/qemu-ifup kvm-ifup
	newins scripts/qemu-ifdown kvm-ifdown

	dodoc qemu/pc-bios/README
	newdoc qemu/qemu-doc.html kvm-doc.html
	newdoc qemu/qemu-tech.html kvm-tech.html
}

pkg_postinst() {
	elog "If you don't have kvm compiled into the kernel, make sure you have"
	elog "the kernel module loaded before running kvm. The easiest way to"
	elog "ensure that the kernel module is loaded is to load it on boot."
	elog "For AMD CPUs the module is called 'kvm-amd'"
	elog "For Intel CPUs the module is called 'kvm-intel'"
	elog "Please review /etc/conf.d/modules for how to load these"
	elog
	elog "Make sure your user is in the 'kvm' group"
	elog "Just run 'gpasswd -a <USER> kvm', then have <USER> re-login."
	elog
	elog "You will need the Universal TUN/TAP driver compiled into your"
	elog "kernel or loaded as a module to use the virtual network device"
	elog "if using -net tap.  You will also need support for 802.1d"
	elog "Ethernet Bridging and a configured bridge if using the provided"
	elog "kvm-ifup script from /etc/kvm."
	echo
}
