# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson

DESCRIPTION="Disk Utility for GNOME using udisks"
HOMEPAGE="https://git.gnome.org/browse/gnome-disk-utility"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="fat gnome systemd"

COMMON_DEPEND="
	>=app-arch/xz-utils-5.0.5
	>=app-crypt/libsecret-0.7
	>=dev-libs/glib-2.60.0:2[dbus]
	dev-libs/libpwquality
	>=media-libs/libcanberra-0.1[gtk3]
	>=media-libs/libdvdread-4.2.0
	>=sys-fs/udisks-2.7.6:2
	>=x11-libs/gtk+-3.16.0:3
	>=x11-libs/libnotify-0.7:=
	systemd? ( >=sys-apps/systemd-209:0= )
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	fat? ( sys-fs/dosfstools )
	gnome? ( >=gnome-base/gnome-settings-daemon-3.8 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50.2
	dev-libs/appstream-glib
	dev-libs/libxslt
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use systemd enable-libsystemd)
		-Denable-gsd-plugin=$(usex gnome true false)
	)

	meson_src_configure
}
