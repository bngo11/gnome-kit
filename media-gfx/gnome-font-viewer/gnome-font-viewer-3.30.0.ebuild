# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson

DESCRIPTION="Font viewer for GNOME"
HOMEPAGE="https://git.gnome.org/browse/gnome-font-viewer"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.35.1:2
	gnome-base/gnome-desktop:3=
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=media-libs/harfbuzz-0.9.9
	>=x11-libs/gtk+-3.20:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
