# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION="utility library for higher level dLeyna libraries"
HOMEPAGE="https://01.org/dleyna/"
SRC_URI="https://01.org/sites/default/files/downloads/dleyna/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.0/4"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/gupnp-1.1.2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"


src_prepare() {
	default
	eapply "${FILESDIR}/${P}-gupnp.patch"
}

src_install() {
	default
	prune_libtool_files
}
