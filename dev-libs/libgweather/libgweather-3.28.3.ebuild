# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome-meson vala

DESCRIPTION="Library to access weather information from online services"
HOMEPAGE="https://wiki.gnome.org/Projects/LibGWeather"

LICENSE="GPL-2+"
SLOT="2/3-6" # subslot = 3-(libgweather-3 soname suffix)
KEYWORDS="*"

IUSE="glade +introspection vala doc"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND="
	>=x11-libs/gtk+-3.13.5:3[introspection?]
	>=dev-libs/glib-2.35.1:2
	>=net-libs/libsoup-2.44:2.4
	>=dev-libs/libxml2-2.6.0:2
	sci-geosciences/geocode-glib
	>=sys-libs/timezone-data-2010k

	glade? ( >=dev-util/glade-3.16:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-applets-2.22.0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		$(meson_use glade glade_catalog) \
		$(meson_use vala enable_vala) \
		$(meson_use doc gtk_doc)
}
