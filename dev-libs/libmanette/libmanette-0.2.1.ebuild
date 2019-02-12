# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome-meson vala

DESCRIPTION="A simple GObject game controller library."
HOMEPAGE="https://gitlab.gnome.org/aplazas/libmanette"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgudev-232
	>=dev-libs/libevdev-1.4.5
"

DEPEND="${RDEPEND}
	${vala_depend}
"

src_prepare() {
	gnome-meson_src_prepare
	vala_src_prepare
}
