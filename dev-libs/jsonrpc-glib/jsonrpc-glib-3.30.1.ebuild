# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome-meson multilib-minimal vala

DESCRIPTION="JSON RPC GLIB"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="doc +introspection +vala"

RDEPEND="
	>=dev-libs/glib-2.53.4:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	use vala && vala_src_prepare
	gnome-meson_src_prepare
}

multilib_src_configure() {
	gnome-meson_src_configure \
		-Dwith_introspection=$(multilib_native_usex introspection true false) \
		$(meson_use vala with_vapi) \
		$(meson_use doc enable_gtk_doc)
}

multilib_src_compile() {
	gnome-meson_src_compile
}

multilib_src_install() {
	gnome-meson_src_install
}
