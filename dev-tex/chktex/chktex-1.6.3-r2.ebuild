# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Checks latex source for common mistakes"
HOMEPAGE="http://baruch.ev-en.org/proj/chktex/"
SRC_URI="http://baruch.ev-en.org/proj/chktex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc"

DEPEND="virtual/latex-base
	dev-lang/perl
	sys-apps/groff
	doc? ( dev-tex/latex2html )"

src_compile() {
	econf `use_enable debug debug-info` || die
	emake || die
	if use doc ; then
		make html
	fi
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc ChkTeX.readme NEWS
	if use doc ; then
		dohtml HTML/ChkTeX/*
		dodoc HTML/ChkTeX.tex
	fi
	doman chktex.1 chkweb.1
}
