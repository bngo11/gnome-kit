# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.36"

inherit gnome2 meson vala

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.58.0:2
	>=gnome-base/dconf-0.31.2
	>=x11-libs/gtk+-3.22.27:3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"

src_prepare() {
	default
	vala_src_prepare
}
