# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
PYTHON_REQ_USE="xml"

inherit eutils gnome.org meson distutils-r1

DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	app-text/docbook-xml-dtd"
DEPEND="${RDEPEND}"

# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-${PV}:2"

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-2.59.2-man-page.patch"
	eapply "${FILESDIR}/${PN}-2.56.0-sitedir.patch"
}

src_configure() {
	local emesonargs=(
		-Dman=true
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile

	S="${WORKDIR}/gdbus-codegen-${PV}-build/gio/gdbus-2.0/codegen"
	cd "${S}"

	distutils-r1_python_prepare_all

	cp "${FILESDIR}/setup.py-2.32.4" setup.py || die "cp failed"
	sed -e "s/@PV@/${PV}/" -i setup.py || die "sed setup.py failed"
}

src_test() {
	einfo "Skipping tests. This package is tested by dev-libs/glib"
	einfo "when merged with FEATURES=test"
}

python_install_all() {
	distutils-r1_python_install_all # no-op, but prevents QA warning
	doman "${WORKDIR}/gdbus-codegen-${PV}-build/docs/reference/gio/gdbus-codegen.1"
}
