# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs versionator virtualx libtool autotools

TEXMF_PATH=/usr/share/texmf

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2"

SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${PN/-core/}-basicbin-${PV}.tar.bz2
	mirror://gentoo/${PN/-core/}-binextra-${PV}.tar.bz2"

KEYWORDS="~amd64 ~x86"
#IUSE="lesstif motif neXt X Xaw3d doc"
IUSE="X doc"

# Not ideal, especially with the modularized way : some packages need only
# texlive-core, ie, the binaries, some other use virtual/tetex to have
# a fully working latex installation to compile some .tex files...
PROVIDE="virtual/tetex"

MODULAR_X_DEPEND="X? ( || ( (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libXaw
				x11-libs/libXfont
			)
			virtual/x11
		)
	)"

DEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/cstetex
	!app-text/tetex
	!<app-text/texlive-2007
	!app-text/xetex
	sys-apps/ed
	sys-libs/zlib
	>=media-libs/libpng-1.2.1
	sys-libs/ncurses
	>=media-libs/t1lib-5.0.2
	media-libs/gd
	app-arch/unzip
	=media-libs/freetype-2*
	dev-libs/icu
	media-libs/fontconfig
	>=net-libs/libwww-5.3.2-r1"
	#X? ( motif? ( lesstif? ( x11-libs/lesstif )
	#	 !lesstif? ( x11-libs/openmotif ) )
	#	 !motif? ( neXt? ( x11-libs/neXtaw )
	#	 !neXt? ( Xaw3d? ( x11-libs/Xaw3d ) ) )
	#	 !app-text/xdvik
	#)

RDEPEND="${DEPEND}
	dev-lang/ruby"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

#	epatch "${FILESDIR}/${PV}/${P}-use-system-libtool.patch"
	epatch "${FILESDIR}/${PV}/${P}-gentoo-texmf-site.patch"
	epatch "${FILESDIR}/${PV}/${P}-mpware.patch"
	epatch "${FILESDIR}/${PV}/${P}-libteckit-asneeded.patch"

# it is also affected by bug 170861
	epatch "${FILESDIR}/${PV}/tetex-3.0-CVE-2007-0650.patch"

# Bug #188172 and bug #185225
	epatch "${FILESDIR}/${PV}/tetex-3.0_p1-xpdf-CVE-2007-3387.patch"
	

	sed -i -e "/mktexlsr/,+3d" -e "s/\(updmap-sys\)/\1 --nohash/" \
		Makefile.in || die "sed failed"

	for i in ${PN/-core/}-basicbin-${PV}/*zip ${PN/-core/}-binextra-${PV}/*zip;
	do
		einfo "Unpacking ${i}"
		unzip -q ${i}
	done

	elibtoolize

	cd libs/teckit
	eautoreconf
}

src_compile() {
	local my_conf

	export LC_ALL=C
	tc-export CC CXX

	#filter-flags "-fstack-protector" "-Os"
	#use amd64 && replace-flags "-O3" "-O2"

#	if use X ; then
#		my_conf="${my_conf} --with-xdvik --with-oxdvik"
#		if use motif ; then
#			if use lesstif ; then
#				append-ldflags -L/usr/X11R6/lib/lesstif -R/usr/X11R6/lib/lesstif
#				export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include/lesstif"
#			fi
#			my_conf="${my_conf} --with-xdvi-x-toolkit=motif"
#		elif use neXt ; then
#			my_conf="${my_conf} --with-xdvi-x-toolkit=neXtaw"
#		elif use Xaw3d ; then
#			my_conf="${my_conf} --with-xdvi-x-toolkit=xaw3d"
#		else
#			my_conf="${my_conf} --with-xdvi-x-toolkit=xaw"
#		fi
#	else
#		my_conf="${my_conf} --without-xdvik --without-oxdvik"
#	fi

	econf --bindir=/usr/bin \
		--datadir="${S}" \
		--with-system-ncurses \
		--with-system-freetype2 \
		--with-freetype2-include=/usr/include \
		--with-system-t1lib \
		--with-system-gd \
		--with-system-zlib \
		--with-system-pnglib \
		--without-texinfo \
		--without-dialog \
		--without-texi2html \
		--disable-multiplatform \
		--with-epsfwin \
		--with-mftalkwin \
		--with-regiswin \
		--with-tektronixwin \
		--with-unitermwin \
		--with-ps=gs \
		--without-psutils \
		--without-sam2p \
		--without-t1utils \
		--enable-ipc \
		--with-etex \
		--with-xetex \
		--without-dvipng \
		--without-dvipdfm \
		--without-dvipdfmx \
		--without-xdvipdfmx \
		--without-lcdf-typetools \
		--without-pdfopen \
		--without-detex \
		--with-system-icu \
		--without-ttf2pk \
		--without-xdvik --without-oxdvik \
		--enable-shared \
		$(use_with X x) \
		${my_conf} || die "econf failed"


	emake -j1 texmf=${TEXMF_PATH:-/usr/share/texmf} || die "emake failed"
}

src_test() {
	fmtutil --fmtdir "${S}/texk/web2c" --all
	Xmake check || die "Xmake check failed."
}

src_install() {
	insinto /usr/share
	doins -r texmf texmf-dist

	dodir ${TEXMF_PATH:-/usr/share/texmf}/web2c
	einstall bindir="${D}/usr/bin" texmf="${D}${TEXMF_PATH:-/usr/share/texmf}" || die "einstall failed"

	dosbin "${FILESDIR}/texmf-update"

	docinto texk
	cd "${S}/texk"
	dodoc ChangeLog README

	docinto kpathesa
	cd "${S}/texk/kpathsea"
	dodoc BUGS ChangeLog NEWS PROJECTS README

	docinto dviljk
	cd "${S}/texk/dviljk"
	dodoc ChangeLog README NEWS

	docinto dvipsk
	cd "${S}/texk/dvipsk"
	dodoc ChangeLog README

	docinto makeindexk
	cd "${S}/texk/makeindexk"
	dodoc ChangeLog NEWS NOTES README

	docinto ps2pkm
	cd "${S}/texk/ps2pkm"
	dodoc ChangeLog README README.14m

	docinto web2c
	cd "${S}/texk/web2c"
	dodoc ChangeLog NEWS PROJECTS README

	use doc || rm -rf "${D}/usr/share/texmf/doc"

	dodir /var/cache/fonts

	# root group name doesn't exist on Mac OS X
	chown -R 0:0 "${D}/usr/share/texmf"

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c"' > "${D}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c

	cd "${D}/${TEXMF_PATH}"
	for f in $(find . -name '*.cnf' -o -name '*.cfg' -type f | sed -e "s:\./::g") ; do
		if [ "${f/config/}" != "${f}" ] ; then
			continue
		fi
		dodir /etc/texmf/$(dirname ${f})
		mv "${D}/${TEXMF_PATH}/${f}" "${D}/etc/texmf/$(dirname ${f})" || die "mv ${f} failed."
		dosym /etc/texmf/${f} ${TEXMF_PATH}/${f}
	done

	# take care of updmap.cfg, fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{updmap.d,fmtutil.d,texmf.d}
	mv "${D}/etc/texmf/web2c/updmap.cfg" "${D}/etc/texmf/updmap.d/00updmap.cfg" || die "moving updmap.cfg failed"
	mv "${D}/etc/texmf/web2c/fmtutil.cnf" "${D}/etc/texmf/fmtutil.d/00fmtutil.cnf" || die "moving fmtutil.cnf failed"
	mv "${D}/etc/texmf/web2c/texmf.cnf" "${D}/etc/texmf/texmf.d/00texmf.cnf" || die "moving texmf.cnf failed"

	# xdvi
	#if use X ; then
	#	dodir /etc/X11/app-defaults /etc/texmf/xdvi
	#	mv "${D}${TEXMF_PATH}/xdvi/XDvi" "${D}/etc/X11/app-defaults" || die "mv XDvi failed"
	#	dosym /etc/X11/app-defaults/XDvi ${TEXMF_PATH}/xdvi/XDvi
	#fi

	keepdir /usr/share/texmf-site

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	cd "${D}/usr/bin/"
	ln -snf tex virtex
	ln -snf pdftex pdfvirtex
}

#pkg_preinst() {
#	ewarn "Removing ${ROOT}usr/share/texmf/web2c"
#	rm -rf "${ROOT}usr/share/texmf/web2c"
#}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi

	elog
	elog "If you have configuration files in /etc/texmf to merge,"
	elog "please update them and run /usr/sbin/texmf-update."
	elog
}
