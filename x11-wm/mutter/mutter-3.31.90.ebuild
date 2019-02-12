# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome-meson virtualx

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://git.gnome.org/browse/mutter/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="elogind +gles2 input_devices_wacom +introspection test udev wayland"
REQUIRED_USE="
	wayland? ( elogind )
"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
COMMON_DEPEND="
	>=dev-libs/atk-2.5.3
	>=x11-libs/gdk-pixbuf-2:2
	>=dev-libs/json-glib-0.12.0
	>=x11-libs/pango-1.30[introspection?]
	>=x11-libs/cairo-1.14[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.53.4:2[dbus]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity
	>=media-libs/mesa-17.2.0[egl]

	gles2? ( media-libs/mesa[gles2] )
	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	udev? ( >=virtual/libgudev-232:= )
	wayland? (
		>=dev-libs/libinput-1.4
		>=dev-libs/wayland-1.6.90
		>=dev-libs/wayland-protocols-1.9
		>=media-libs/mesa-10.3[egl,gbm,wayland]
		|| ( sys-auth/elogind sys-apps/systemd )
		>=virtual/libgudev-232:=
		>=virtual/libudev-136:=
		x11-base/xorg-server[wayland]
		x11-libs/libdrm:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	x11-base/xorg-proto
	>=dev-libs/pipewire-0.2.5
	test? ( app-text/docbook-xml-dtd:4.5 )
	wayland? ( >=sys-kernel/linux-headers-4.4 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_prepare() {
	if use elogind; then
		eapply "${FILESDIR}"/${PN}-3.32.0-support-elogind.patch
	fi

	gnome-meson_src_prepare
}

src_configure() {
	# Prefer gl driver by default
	# GLX is forced by mutter but optional in clutter
	# xlib-egl-platform required by mutter x11 backend
	# native backend without wayland is useless
	gnome-meson_src_configure \
		-Dopengl=true \
		-Dglx=true \
		-Degl=true \
		-Dsm=true \
		-Dstartup_notification=true \
		-Dverbose=true \
		-Dremote_desktop=true \
		-Dpango_ft2=true \
		$(meson_use gles2 gles2)        \
		$(meson_use introspection introspection) \
		$(meson_use wayland wayland) \
		$(meson_use wayland egl-device) \
		# $(meson_use wayland wayland_eglstream) \
		$(meson_use wayland native-backend) \
		$(meson_use input_devices_wacom libwacom) \
		$(meson_use udev udev)
}

src_test() {
	virtx emake check
}
