# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome-meson vala

DESCRIPTION="Dominate the board in a classic version of Reversi"
HOMEPAGE="https://wiki.gnome.org/Apps/Iagno"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.15:3
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.14
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome-meson_src_prepare
	vala_src_prepare
}
