# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk context cyrillic doc extra games graphics humanities music omega
	perl png pstricks publishers science xetex xml X
	linguas_bg linguas_zh linguas_cs linguas_sk linguas_nl
	linguas_en linguas_fi linguas_fr linguas_de linguas_el
	linguas_it linguas_ja linguas_ko linguas_mn linguas_pl
	linguas_pt linguas_ru linguas_es linguas_th linguas_tr
	linguas_uk linguas_vi linguas_af linguas_ar linguas_hr
	linguas_da linguas_he linguas_la linguas_no linguas_sv
	linguas_en_GB"


TEXLIVE_CAT="dev-texlive"

BLOCKS="!dev-tex/memoir
	!dev-tex/lineno
	!dev-tex/SIunits
	!dev-tex/floatflt
	!dev-tex/g-brief
	!dev-tex/xkeyval
	!dev-tex/vntex
	!dev-tex/koma-script
	!dev-tex/currvita
	!dev-tex/eurosym
	!dev-tex/extsizes"

DEPEND=">=app-text/texlive-source-2007"
RDEPEND="${DEPEND}
	${BLOCKS}
	app-text/psutils
	${TEXLIVE_CAT}/texlive-psutils
	media-gfx/sam2p
	app-text/texi2html
	sys-apps/texinfo
	app-text/t1utils
	dev-util/dialog
	app-text/lcdf-typetools
	=media-libs/freetype-1*
	dev-tex/detex
	png? ( app-text/dvipng )
	X? ( app-text/xdvik )
	${TEXLIVE_CAT}/texlive-fontbin
	${TEXLIVE_CAT}/texlive-basic
	${TEXLIVE_CAT}/texlive-fontsrecommended
	${TEXLIVE_CAT}/texlive-latex
	${TEXLIVE_CAT}/texlive-latex3
	${TEXLIVE_CAT}/texlive-latexrecommended
	>=dev-tex/xcolor-2.11
	>=dev-tex/latex-beamer-3.06
	${TEXLIVE_CAT}/texlive-metapost
	${TEXLIVE_CAT}/texlive-genericrecommended
	perl? ( >=dev-lang/perl-5.2 )
	extra? (
		dev-tex/chktex
		${TEXLIVE_CAT}/texlive-bibtexextra
		${TEXLIVE_CAT}/texlive-fontsextra
		${TEXLIVE_CAT}/texlive-formatsextra
		${TEXLIVE_CAT}/texlive-genericextra
		${TEXLIVE_CAT}/texlive-latexextra
		${TEXLIVE_CAT}/texlive-mathextra
		${TEXLIVE_CAT}/texlive-plainextra
	)
	xetex? ( ${TEXLIVE_CAT}/texlive-xetex )
	graphics? ( ${TEXLIVE_CAT}/texlive-pictures
		>=dev-tex/pgf-1.18 )
	science? ( ${TEXLIVE_CAT}/texlive-science )
	publishers? ( ${TEXLIVE_CAT}/texlive-publishers )
	music? ( ${TEXLIVE_CAT}/texlive-music )
	pstricks? ( ${TEXLIVE_CAT}/texlive-pstricks )
	omega? ( ${TEXLIVE_CAT}/texlive-omega )
	context? ( ${TEXLIVE_CAT}/texlive-context )
	games? ( ${TEXLIVE_CAT}/texlive-games )
	humanities? ( ${TEXLIVE_CAT}/texlive-humanities )
	xml? ( ${TEXLIVE_CAT}/texlive-htmlxml )
	doc? (
		${TEXLIVE_CAT}/texlive-documentation-base
		linguas_bg? ( ${TEXLIVE_CAT}/texlive-documentation-bulgarian )
		linguas_zh? ( ${TEXLIVE_CAT}/texlive-documentation-chinese )
		linguas_cs? ( ${TEXLIVE_CAT}/texlive-documentation-czechslovak )
		linguas_sk? ( ${TEXLIVE_CAT}/texlive-documentation-czechslovak )
		linguas_nl? ( ${TEXLIVE_CAT}/texlive-documentation-dutch )
		linguas_en? ( ${TEXLIVE_CAT}/texlive-documentation-english )
		linguas_fi? ( ${TEXLIVE_CAT}/texlive-documentation-finnish )
		linguas_fr? ( ${TEXLIVE_CAT}/texlive-documentation-french )
		linguas_de? ( ${TEXLIVE_CAT}/texlive-documentation-german )
		linguas_el? ( ${TEXLIVE_CAT}/texlive-documentation-greek )
		linguas_it? ( ${TEXLIVE_CAT}/texlive-documentation-italian )
		linguas_ja? ( ${TEXLIVE_CAT}/texlive-documentation-japanese )
		linguas_ko? ( ${TEXLIVE_CAT}/texlive-documentation-korean )
		linguas_mn? ( ${TEXLIVE_CAT}/texlive-documentation-mongolian )
		linguas_pl? ( ${TEXLIVE_CAT}/texlive-documentation-polish )
		linguas_pt? ( ${TEXLIVE_CAT}/texlive-documentation-portuguese )
		linguas_ru? ( ${TEXLIVE_CAT}/texlive-documentation-russian )
		linguas_es? ( ${TEXLIVE_CAT}/texlive-documentation-spanish )
		linguas_th? ( ${TEXLIVE_CAT}/texlive-documentation-thai )
		linguas_tr? ( ${TEXLIVE_CAT}/texlive-documentation-turkish )
		linguas_uk? ( ${TEXLIVE_CAT}/texlive-documentation-ukrainian )
		linguas_vi? ( ${TEXLIVE_CAT}/texlive-documentation-vietnamese )
	)
	linguas_af? ( ${TEXLIVE_CAT}/texlive-langafrican )
	linguas_ar? ( ${TEXLIVE_CAT}/texlive-langarab )
	cjk? ( ${TEXLIVE_CAT}/texlive-langcjk )
	linguas_hr? ( ${TEXLIVE_CAT}/texlive-langcroatian )
	cyrillic? ( ${TEXLIVE_CAT}/texlive-langcyrillic )
	linguas_cs? ( ${TEXLIVE_CAT}/texlive-langczechslovak )
	linguas_sk? ( ${TEXLIVE_CAT}/texlive-langczechslovak )
	linguas_da? ( ${TEXLIVE_CAT}/texlive-langdanish )
	linguas_nl? ( ${TEXLIVE_CAT}/texlive-langdutch )
	linguas_fi? ( ${TEXLIVE_CAT}/texlive-langfinnish )
	linguas_fr? ( ${TEXLIVE_CAT}/texlive-langfrench )
	linguas_de? ( ${TEXLIVE_CAT}/texlive-langgerman )
	linguas_el? ( ${TEXLIVE_CAT}/texlive-langgreek )
	linguas_he? ( ${TEXLIVE_CAT}/texlive-langhebrew )
	linguas_hu? ( ${TEXLIVE_CAT}/texlive-langhungarian )
	linguas_it? ( ${TEXLIVE_CAT}/texlive-langitalian )
	linguas_la? ( ${TEXLIVE_CAT}/texlive-langlatin )
	linguas_mn? ( ${TEXLIVE_CAT}/texlive-langmongolian )
	linguas_no? ( ${TEXLIVE_CAT}/texlive-langnorwegian )
	linguas_pl? ( ${TEXLIVE_CAT}/texlive-langpolish )
	linguas_pt? ( ${TEXLIVE_CAT}/texlive-langportuguese )
	linguas_es? ( ${TEXLIVE_CAT}/texlive-langspanish )
	linguas_sv? ( ${TEXLIVE_CAT}/texlive-langswedish )
	linguas_en_GB? ( ${TEXLIVE_CAT}/texlive-langukenglish )
	linguas_vi? ( ${TEXLIVE_CAT}/texlive-langvietnamese )
"

# What to do with those ?
# ${TEXLIVE_CAT}/texlive-langother
