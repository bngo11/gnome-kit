# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 systemd

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Vino"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="crypt debug gnome-keyring ipv6 jpeg ssl +telepathy zeroconf +zlib"
# bug #394611; tight encoding requires zlib encoding
REQUIRED_USE="jpeg? ( zlib )"

# cairo used in vino-fb
# libSM and libICE used in eggsmclient-xsmp
RDEPEND="
	>=dev-libs/glib-2.26:2
	>=dev-libs/libgcrypt-1.1.90:0=
	>=x11-libs/gtk+-3:3

	x11-libs/cairo:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/pango[X]

	>=x11-libs/libnotify-0.7.0:=

	crypt? ( >=dev-libs/libgcrypt-1.1.90:0= )
	gnome-keyring? ( app-crypt/libsecret )
	jpeg? ( virtual/jpeg:0= )
	ssl? ( >=net-libs/gnutls-2.2.0:= )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.18 )
	zeroconf? ( >=net-dns/avahi-0.6:=[dbus] )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}
	app-crypt/libsecret
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"
# libsecret is always required at build time per bug 322763

PATCHES=(
	"${FILESDIR}/vino-return-error-if-X11-is-no-detected.patch"
	"${FILESDIR}/vino-segfaults-on-wayland.patch"
)

src_configure() {
	gnome2_src_configure \
		$(use_enable ipv6) \
		$(use_with crypt gcrypt) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_with gnome-keyring secret) \
		$(use_with jpeg) \
		$(use_with ssl gnutls) \
		$(use_with telepathy) \
		$(use_with zeroconf avahi) \
		$(use_with zlib) \
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
}

src_install() {
	gnome2_src_install
	dosym '/usr/share/applications/vino-server.desktop' /etc/xdg/autostart/vino-server.desktop
}
