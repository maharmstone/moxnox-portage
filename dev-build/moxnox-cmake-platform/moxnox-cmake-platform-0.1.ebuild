# Copyright 2026 Mark Harmstone
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CMake platform modules for Moxnox targets"
HOMEPAGE="https://moxnox.dev/"
S="${WORKDIR}"

# Transcribed from CMake's CYGWIN/Windows-GNU platform modules
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-build/cmake"

src_install() {
	insinto /usr/share/cmake/Modules/Platform
	doins "${FILESDIR}"/Moxnox.cmake \
		"${FILESDIR}"/Moxnox-GNU.cmake \
		"${FILESDIR}"/Moxnox-GNU-C.cmake \
		"${FILESDIR}"/Moxnox-GNU-CXX.cmake \
		"${FILESDIR}"/Moxnox-Clang-C.cmake \
		"${FILESDIR}"/Moxnox-Clang-CXX.cmake \
		"${FILESDIR}"/Moxnox-Clang-ASM.cmake
}
