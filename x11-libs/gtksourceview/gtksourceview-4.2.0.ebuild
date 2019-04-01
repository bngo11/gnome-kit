# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MIN_API_VERSION="0.24"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala virtualx

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="https://wiki.gnome.org/Projects/GtkSourceView"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="4"

IUSE="glade +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="*"

RDEPEND="
	!x11-libs/gtksourceview:4.0
	>=dev-libs/glib-2.48:2
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/gtk+-3.20:3[introspection?]
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.25
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable glade glade-catalog) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_test() {
	virtx emake check
}

src_install() {
	gnome2_src_install

	insinto /usr/share/${PN}-4/language-specs
	doins "${FILESDIR}"/2.0/gentoo.lang

	# Avoid conflict with gtksourceview:3.0 glade-catalog
	# TODO: glade doesn't actually show multiple GtkSourceView widget collections, so with both installed, can't really be sure which ones are used
	if use glade; then
		mv "${ED}"/usr/share/glade/catalogs/gtksourceview.xml "${ED}"/usr/share/glade/catalogs/gtksourceview-${SLOT}.xml || die
	fi
}