# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

inherit gnome-meson readme.gentoo-r1 virtualx

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
IUSE="doc gnome +introspection packagekit +previewer selinux sendto test"

KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
# need org.gnome.SessionManager service (aka gnome-session) but cannot find it
RESTRICT="test"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.2.1
	>=dev-libs/glib-2.51.2:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.26:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	>=gnome-base/gsettings-desktop-schemas-3.8.0
	>=sys-libs/libselinux-2
	x11-libs/libX11

	doc? ( >=dev-util/gtk-doc-am-1.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	app-misc/tracker
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.33
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-base/xorg-proto
	>=media-libs/gexiv2-0.10.0
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"
PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	>=gnome-extra/nautilus-tracker-tags-0.12
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]
"
# Need gvfs[gtk] for recent:/// support

PATCHES=( "${FILESDIR}/${P}-thumbnail.patch" )

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		-Dprofiling=false \
		-Dtests=$(usex test all headless) \
		$(meson_use doc docs) \
		$(meson_use sendto extensions) \
		$(meson_use packagekit packagekit) \
		$(meson_use selinux selinux)
}

src_test() {
	virtx meson_src_test
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome-meson_src_install
}

pkg_postinst() {
	gnome-meson_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
