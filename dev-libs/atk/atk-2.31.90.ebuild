# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="doc +introspection nls"

RDEPEND="
	>=dev-libs/glib-2.34.3:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1
	nls? ( >=sys-devel/gettext-0.19.2 )
"

src_prepare() {
	gnome-meson_src_prepare
}

multilib_src_configure() {
	gnome-meson_src_configure \
		$(meson_use introspection introspection) \
		$(meson_use doc docs)
}

multilib_src_install() {
	gnome-meson_src_install
}
