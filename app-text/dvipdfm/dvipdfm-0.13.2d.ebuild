# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="DVI to PDF translator"
SRC_URI="http://gaspra.kettering.edu/dvipdfm/${P}.tar.gz"
HOMEPAGE="http://gaspra.kettering.edu/dvipdfm/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="!>=app-text/tetex-2
	>=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	!>=app-text/tetex-2
	!app-text/ptex
	!app-text/cstetex
	virtual/tetex"

S="${WORKDIR}/${PN}"

src_install () {
	einstall || die "einstall failed!"

	dodoc AUTHORS ChangeLog Credits NEWS OBTAINING README* TODO

	docinto doc
	dodoc doc/*
	
	docinto latex-support
	dodoc latex-support/*
	
	dodir /usr/share/texmf-dist/fonts/enc/dvipdfm
	mv "${D}/usr/share/texmf/dvipdfm/base/"* "${D}/usr/share/texmf-dist/fonts/enc/dvipdfm"
	
	dodir /usr/share/texmf-dist/fonts/map/dvipdfm
	mv "${D}/usr/share/texmf/dvipdfm/config/"*.map "${D}/usr/share/texmf-dist/fonts/map/dvipdfm"
	
	insinto /usr/share/texmf/tex/latex/dvipdfm/
	doins latex-support/dvipdfm.def
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi
}
