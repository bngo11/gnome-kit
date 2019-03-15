# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.3"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.59.0:2.6[doc?]
	>=dev-libs/atk-2.18.0
	>=dev-libs/libsigc++-2.3.2:2
"
RDEPEND="${COMMON_DEPEND}
	!<dev-cpp/gtkmm-2.22.0
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

pkg_setup() {
	export CFLAGS="-std=c++17 $CFLAGS"
	export CXXFLAGS="-std=c++17 $CXXFLAGS"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
