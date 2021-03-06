# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Fit falling blocks together"
HOMEPAGE="https://wiki.gnome.org/Apps/Quadrapassel"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/clutter-1:1.0
	>=media-libs/clutter-gtk-0.91.6:1.0
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.12:3
	>=sys-libs/libmanette-0.2
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
