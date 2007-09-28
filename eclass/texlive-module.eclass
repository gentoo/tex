# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Alexis Ballier <aballier@gentoo.org>
# Purpose: Provide generic install functions so that modular texlive's texmf ebuilds will
# only have to inherit this eclass.
# Ebuilds have to provide TEXLIVE_MODULE_CONTENTS variable that contains the list
# of packages that it will install.
#

inherit texlive-common

HOMEPAGE="http://www.tug.org/texlive/"

for i in ${TEXLIVE_MODULE_CONTENTS}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.zip"
done

COMMON_DEPEND=">=app-text/texlive-core-${PV}
	${TEXLIVE_MODULES_DEPS}"

DEPEND="${COMMON_DEPEND}
	app-arch/unzip"

RDEPEND="${COMMON_DEPEND}"

IUSE="doc"

S="${WORKDIR}"

texlive-module_src_compile() {
	# Build format files
	for i in texmf/fmtutil/format*.cnf; do
		if test -f "${i}"; then
			einfo "Building format ${i}"
			TEXMFHOME="${S}/texmf:${S}/texmf-dist"\
				fmtutil --cnffile "${i}" --fmtdir "${S}/texmf-var/web2c" --all\
				|| die "failed to build format ${i}"
		fi
	done

	# Generate config files
	for i in "${S}"/texmf/lists/*;
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
	insinto /usr/share
	test -d texmf && doins -r texmf
	test -d texmf-dist && doins -r texmf-dist
	test -d texmf-var && doins -r texmf-var
	use doc && test -d texmf-doc && doins -r texmf-doc

	insinto /etc/texmf/updmap.d
	test -f "${S}/${PN}.cfg" && doins "${S}/${PN}.cfg"
	insinto /etc/texmf/dvips/config
	test -f "${S}/${PN}-config.ps" && doins "${S}/${PN}-config.ps"
	insinto /etc/texmf/dvipdfm/config
	test -f "${S}/${PN}-config" && doins "${S}/${PN}-config"

	texlive-common_handle_config_files
}

texlive-module_pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi
}

texlive-module_pkg_postrm() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_postrm
