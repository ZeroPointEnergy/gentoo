# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit games

if [[ ${PV} == 9999* ]]; then
	inherit autotools mercurial
	EHG_REPO_URI="https://bitbucket.org/rude/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://www.bitbucket.org/rude/${PN}/downloads/${P}-linux-src.tar.gz"
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="dev-games/physfs
	dev-lang/lua[deprecated]
	media-libs/devil[mng,png,tiff]
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl[joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl"
DEPEND="${RDEPEND}
	media-libs/libmng
	media-libs/tiff"

src_prepare() {
	if [[ ${PV} == 9999* ]]; then
		sh platform/unix/gen-makefile || die
		mkdir platform/unix/m4 || die
		eautoreconf
	fi
	epatch "${FILESDIR}"/${P}-freetype2.patch
}

src_install() {
	DOCS="readme.md changes.txt" \
		default
	if [[ "${SLOT}" != "0" ]]; then
		mv "${ED}${GAMES_BINDIR}"/${PN} \
			"${ED}${GAMES_BINDIR}"/${PN}-${SLOT} || die
	fi
}
