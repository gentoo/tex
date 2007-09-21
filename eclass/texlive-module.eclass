# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


HOMEPAGE="http://www.tug.org/texlive/"
SRC_URI="mirror://gentoo/${P}${TEXLIVE_MODULE_EXTRA_PACKAGE_NAME}.tar.bz2"

COMMON_DEPEND=">=app-text/texlive-core-${PV}"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	${TEXLIVE_MODULES_DEPS}"

RDEPEND="${COMMON_DEPEND}
	${TEXLIVE_MODULES_DEPS}"

IUSE="doc"

TEXMF_PATH=/usr/share/texmf

texlive-module_src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir -p "${S}/unpacked"
	cd "${S}/unpacked"

	for i in "${S}"/*zip ; do
		einfo "Unpacking ${i}"
		unzip -q "${i}"
	done
}

texlive-module_src_compile() {
	for i in unpacked/texmf/fmtutil/format*.cnf; do
		einfo "Building format ${i}"
		TEXMFHOME="${S}/unpacked/texmf:${S}/unpacked/texmf-dist"\
			fmtutil --cnffile "${i}" --fmtdir "${S}/unpacked/texmf-var/web2c" --all\
			|| die "failed to build format ${i}"
	done
}

texlive-module_src_install() {
	cd "${S}/unpacked"

	insinto /usr/share
	doins -r texmf
	doins -r texmf-dist
	doins -r texmf-var
	use doc && doins -r texmf-doc


	for i in "${S}"/unpacked/texmf/lists/*;
	do
		grep '^!' "${i}" | tr ' ' '=' |sort|uniq >> "${T}/jobs"
	done

	for j in $(cat "${T}/jobs");
	do
		command=$(echo ${j} | sed 's/.\(.*\)=.*/\1/')
		parameter=$(echo ${j} | sed 's/.*=\(.*\)/\1/')
		case ${command} in
			addMap)
				dodir /etc/texmf/updmap.d
				echo "Map ${parameter}" >> "${D}etc/texmf/updmap.d/${PN}.cfg";;
			addMixedMap)
				dodir /etc/texmf/updmap.d
				echo "MixedMap ${parameter}" >> "${D}etc/texmf/updmap.d/${PN}.cfg";;
			addDvipsMap)
				dodir /etc/texmf/dvips/config
				echo "p	+${parameter}" >> "${D}etc/texmf/dvips/config/config.ps";;
			addDvipdfmMap)
				dodir /etc/texmf/dvipdfm/config
				echo "f	${parameter}" >> "${D}etc/texmf/dvipdfm/config/config";;
		esac
	done

	# Handle config files properly
	cd "${D}${TEXMF_PATH}"
	for f in $(find . -name '*.cnf' -o -name '*.cfg' -type f | sed -e "s:\./::g") ; do
		if [ "${f/config/}" != "${f}" ] ; then
			continue
		fi
		dodir /etc/texmf/$(dirname ${f}).d
		mv "${D}/${TEXMF_PATH}/${f}" "${D}/etc/texmf/$(dirname ${f}).d" || die "mv ${f} failed."
		dosym /etc/texmf/$(dirname ${f}).d/$(basename ${f}) ${TEXMF_PATH}/${f}
	done
}

texlive-module_pkg_postinst() {
		texmf-update
}

texlive-module_pkg_postrm() {
	texmf-update
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
