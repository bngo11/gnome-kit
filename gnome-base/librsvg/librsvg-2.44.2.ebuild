# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 multilib-minimal vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="+introspection tools +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.48.0:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-libs/libcroco-0.6.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	tools? ( >=x11-libs/gtk+-3.10.0:3 )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	>=dev-lang/rust-1.26
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=653323
	eapply "${FILESDIR}/${PN}-2.42.2-gtk-optional.patch"
	eapply "${FILESDIR}"/${PN}-2.44.2-dladdr-libdl.patch

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare

	# Work around issue where vala file is expected in local
	# directory instead of source directory.
	for v in $(multilib_get_enabled_abi_pairs); do
		build_dir="${S%%/}-${v}"
		mkdir -p "${build_dir}"
		cp -p "${S}/Rsvg-2.0-custom.vala" "${build_dir}"|| die
	done
}

multilib_src_configure() {
	local myconf=()

	# -Bsymbolic is not supported by the Darwin toolchain
	if [[ ${CHOST} == *-darwin* ]]; then
		myconf+=( --disable-Bsymbolic )
	fi

	if [[ ${ABI} == "x86" ]]; then
		myconf+=( --host=i686-unknown-linux-gnu )
	else
		myconf+=( --host=x86_64-unknown-linux-gnu )
	fi

	# --disable-tools even when USE=tools; the tools/ subdirectory is useful
	# only for librsvg developers
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-tools \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_with tools gtk3) \
		$(multilib_native_use_enable vala) \
		--enable-pixbuf-loader \
		"${myconf[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_compile() {
	# causes segfault if set, see bug #411765
	unset __GL_NO_DSO_FINALIZER
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postrm
}
