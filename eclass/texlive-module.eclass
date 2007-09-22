# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Alexis Ballier <aballier@gentoo.org>
# Purpose: Provide generic install functions so that modular texlive's texmf ebuilds will
# only have to inherit this eclass.
#

inherit texlive-common

HOMEPAGE="http://www.tug.org/texlive/"
SRC_URI="mirror://gentoo/${P}${TEXLIVE_MODULE_EXTRA_PACKAGE_NAME}.tar.bz2"

COMMON_DEPEND=">=app-text/texlive-core-${PV}"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	${TEXLIVE_MODULES_DEPS}"

RDEPEND="${COMMON_DEPEND}
	${TEXLIVE_MODULES_DEPS}"

IUSE="doc"

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
	# Build format files
	for i in unpacked/texmf/fmtutil/format*.cnf; do
		if test -f "${i}"; then
			einfo "Building format ${i}"
			TEXMFHOME="${S}/unpacked/texmf:${S}/unpacked/texmf-dist"\
				fmtutil --cnffile "${i}" --fmtdir "${S}/unpacked/texmf-var/web2c" --all\
				|| die "failed to build format ${i}"
		fi
	done

	# Generate config files
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
				echo "Map ${parameter}" >> "${S}/${PN}.cfg";;
			addMixedMap)
				echo "MixedMap ${parameter}" >> "${S}/${PN}.cfg";;
			addDvipsMap)
				echo "p	+${parameter}" >> "${S}/${PN}-config.ps";;
			addDvipdfmMap)
				echo "f	${parameter}" >> "${S}/${PN}-config";;
		esac
	done
}

texlive-module_src_install() {
	cd "${S}/unpacked"

	insinto /usr/share
	doins -r texmf
	doins -r texmf-dist
	doins -r texmf-var
	use doc && doins -r texmf-doc

	insinto /etc/texmf/updmap.d
	doins "${S}/${PN}.cfg"
	insinto /etc/texmf/dvips/config/config.ps
	doins "${S}/${PN}-config.ps"
	insinto /etc/texmf/dvipdfm/config
	doins "${S}/${PN}-config"

	texlive-common_handle_config_files
}

texlive-module_pkg_postinst() {
		texmf-update
}

texlive-module_pkg_postrm() {
	texmf-update
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
