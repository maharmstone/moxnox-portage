# Copyright 2026 Mark Harmstone
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev

DESCRIPTION="Moxnox runtime: headers, import libraries and CRT objects"
HOMEPAGE="https://moxnox.dev/"

_moxnox_target=${CATEGORY#cross-}
_moxnox_target=${_moxnox_target#cross_llvm-}

SRC_URI="https://moxnox.dev/moxnox-headers-${PV}.tar.xz"

case ${_moxnox_target} in
	x86_64-pc-moxnox)  SRC_URI+=" https://moxnox.dev/moxnox-libraries-amd64-${PV}.tar.xz" ;;
	aarch64-pc-moxnox) SRC_URI+=" https://moxnox.dev/moxnox-libraries-aarch64-${PV}.tar.xz" ;;
	*)
		# Canonical sys-libs placement: only reached when generating the
		# Manifest, which must cover every target's tarball.
		SRC_URI+=" https://moxnox.dev/moxnox-libraries-amd64-${PV}.tar.xz
		https://moxnox.dev/moxnox-libraries-aarch64-${PV}.tar.xz" ;;
esac

S="${WORKDIR}"

# Moxnox's own code plus prebuilt mingw-w64 pieces (crt objects and
# support archives, transitional until the vendored crt)
LICENSE="all-rights-reserved ZPL public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="headers-only"

# The contents are PE objects; Portage would use the wrong strip executable
RESTRICT="strip"

pkg_setup() {
	target_is_not_host || die "${PN} must be installed as cross-\${CTARGET}/${PN}"
}

src_install() {
	insinto /usr/${CTARGET}/usr/include
	doins -r include/.

	# Win32-tier headers for the crtstuff/unwinder parts of libgcc
	# (t-moxnox reaches them via -idirafter =/mingw-compat/include),
	# so these are needed even for a headers-only bootstrap stage
	insinto /usr/${CTARGET}/mingw-compat
	doins -r mingw-compat/.

	if ! use headers-only; then
		insinto /usr/${CTARGET}/usr/lib
		doins -r lib/.
	fi
}
