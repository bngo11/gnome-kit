# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 toolchain-funcs meson

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="X doc +introspection test"

RDEPEND="
	>=media-libs/harfbuzz-1.2.3:=[glib(+),truetype(+)]
	>=dev-libs/glib-2.34.3:2
	>=media-libs/fontconfig-2.10.92:1.0=
	>=media-libs/freetype-2.5.0.1:2=
	>=x11-libs/cairo-1.12.14-r4:=[X?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXft-2.3.1-r1
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=dev-libs/fribidi-0.19
	virtual/pkgconfig
	test? ( media-fonts/cantarell )
	X? ( >=x11-proto/xproto-7.0.24 )
	!<=sys-devel/autoconf-2.63:2.5
"

src_configure() {
	tc-export CXX

	local emesonargs=(
		$(meson_use introspection gir)
		$(meson_use doc enable_docs)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
