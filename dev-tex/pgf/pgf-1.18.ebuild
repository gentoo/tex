# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="pgf -- The TeX Portable Graphic Format"
HOMEPAGE="http://sourceforge.net/projects/pgf"
SRC_URI="mirror://sourceforge/pgf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86"
IUSE=""
DEPEND="!>=app-text/tetex-3.0
	>=dev-tex/xcolor-2.00
	|| ( dev-texlive/texlive-latexrecommended >=dev-tex/xkeyval-1.8 )"

src_install() {
	insinto /usr/share/texmf/tex/
	for dir in generic latex plain ; do
		doins -r ${dir} || die "Failed installing"
	done

	dodir /usr/share/doc/${PF}
	insinto /usr/share/doc/${PF}
	doins -r doc/generic/pgf/* || die "Failed doc"
}
