PATCHES=( "${FILESDIR}/texmfcnflua2016.patch" )
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/simpdftex/simpdftex texmf-dist/scripts/texlive/rungs.tlu"
DEPEND="${DEPEND}
!!<dev-texlive/texlive-langcjk-2011
!!<dev-texlive/texlive-langother-2012
!!<dev-texlive/texlive-langgerman-2013
!!<dev-texlive/texlive-langgreek-2013
"
