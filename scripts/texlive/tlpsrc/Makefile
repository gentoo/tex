
include Makefile.common

include Makefile.def

include Makefile.revs

include Makefile.inherits

VERSIONNED_ZIPS = $(DESC:%=%.versionnedzips) $(EXTRA_DIST:%=%.versionnedzips) $(DESC:%=%.docversionnedzips) $(EXTRA_DIST:%=%.docversionnedzips) $(DESC:%=%.srcversionnedzips) $(EXTRA_DIST:%=%.srcversionnedzips)

FULLDESC = $(DESC) $(EXTRA_DIST)

lists : $(FULLDESC:%=%.list) $(FULLDESC:%=%.base)

unpacked : $(FULLDESC:%=%.unpacked)

%.base:
	$(CPF) $(@:texlive-%.base=$(TL_TRUNK)/Master/tlpkg/tlpsrc/collection-%.tlpsrc) $@
	-sh $(@:%.base=%.baseexec) $@

%.list: %.base
	grep -v "^#" $< | grep "depend " | awk '{print $$2}'  | grep -v "collection" | tr '\n' ' ' > $@
	-sh $(@:%.list=%.extraexec) $@
	echo "$(@:texlive-%.list=collection-%)" >> $@

%.doclist: %.tlpobj
	./gendoc.sh $(shell cat $(<:%.tlpobj=%.list)) > $@

%.srclist: %.tlpobj
	./gensrc.sh $(shell cat $(<:%.tlpobj=%.list)) > $@

%.licenselist: %.cataloguehtml
	./getlicense.sh $(shell cat $(@:%.licenselist=%.list)) | sort | uniq | tr '\n' ' ' > $@

%.gentoolicense: %.licenselist
	(./cataloguelicense2gentoolicense.sh $(shell cat $<) ; printf "\nGPL-2\n") | sort | uniq | tr '\n' ' ' > $@

%.desc: %.base
	grep "shortdesc " $< | sed -e "s/shortdesc //" | sed -e "s/.*/DESCRIPTION=\"TeXLive \0\"/" > $@

%.metadata: %.base
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo '<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">' >> $@
	echo '<pkgmetadata>' >> $@
	echo '	<maintainer type="person">' >> $@
	echo '		<email>aballier@gentoo.org</email>' >> $@
	echo '		<name>Alexis Ballier</name>' >> $@
	echo '	</maintainer>' >> $@
	echo '  <maintainer type="project">' >> $@
	echo '     <email>tex@gentoo.org</email>' >> $@
	echo '     <name>Gentoo TeX Project</name>' >> $@
	echo '  </maintainer>' >> $@
	echo '<longdescription lang="en">' >> $@
	grep "longdesc " $< | sed -e "s/longdesc //" >> $@
	echo '</longdescription>' >> $@
	echo '</pkgmetadata>' >> $@

%.deps: %.base
	grep "depend " $< | awk '{print $$2}' | grep "collection" | grep -v "collection-basicbin" | grep -v "collection-fontbin" |  sed -e "s/collection/texlive/g" | sed -e "s/^/>=dev-texlive\//" | sed -e "s/$$/-$(TEXLIVE_VERSION)/" > $@
	-cat $(@:.deps=.extradeps) >> $@

clean:
	$(RMF) $(FULLDESC:%=%.list)
	$(RMF) $(FULLDESC:%=%.srclist)
	$(RMF) $(FULLDESC:%=%.doclist)
	$(RMF) $(FULLDESC:%=%.licenselist)
	$(RMF) $(FULLDESC:%=%.base)
	$(RMF) $(FULLDESC:%=%.versionnedzips)
	$(RMF) $(FULLDESC:%=%.docversionnedzips)
	$(RMF) $(FULLDESC:%=%.srcversionnedzips)
	$(RMF) $(FULLDESC:%=%.unpacked)
	$(RMF) $(DESC:%=%.dotbase)
	$(RMF) $(DESC:%=%.deps)
	$(RMF) $(DESC:%=%.metadata)
	$(RMF) *.tlpobj
	$(RMF) *.tlplic
	$(RMF) *.cataloguehtml
	$(RMF) *.unpacked
	$(RMF) tldir

%.versionnedzips: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.docversionnedzips: %.doclist
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.srcversionnedzips: %.srclist
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.unpacked: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist unpacked
	touch $@

%.tlpobj: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist tlpobj
	touch $@

%.tlplic: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist tlplic
	touch $@

%.cataloguehtml: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist cataloguehtml
	touch $@

%-post.ebuild:
	touch $@

%.extrardepend:
	touch $@

%-preinherit.ebuild:
	touch $@

%.ebuild: %.desc %.deps %.list %.doclist %.srclist %.gentoolicense %-post.ebuild %.extrardepend %-preinherit.ebuild
	cat $(PORTDIR)/header.txt > $@
	printf "EAPI=\"5\"\n\n" >> $@
	echo -n "TEXLIVE_MODULE_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.list) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_DOC_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.doclist) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_SRC_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.srclist) >> $@
	echo "\"" >> $@
	cat $(@:%.ebuild=%-preinherit.ebuild) >> $@
	echo "inherit $(EXTRA_INHERIT) texlive-module" >> $@
	cat $< >> $@
	echo "" >> $@
	echo -n "LICENSE=\"" >> $@
	cat $(@:%.ebuild=%.gentoolicense) >> $@
	echo "\"" >> $@
	echo "SLOT=\"0\"" >> $@
	echo "KEYWORDS=\"~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris\"" >> $@
	echo "IUSE=\"\"" >> $@
	echo -n "DEPEND=\"" >> $@
	cat $(@:%.ebuild=%.deps) >> $@
	echo "\"" >> $@
	echo -n 'RDEPEND="$${DEPEND} ' >> $@
	cat $(@:%.ebuild=%.extrardepend) >> $@
	echo '"' >> $@
	cat $(@:%.ebuild=%-post.ebuild) >> $@

dist: lists $(VERSIONNED_ZIPS) $(EXTRA_DIST:%=%.doclist) $(EXTRA_DIST:%=%.srclist)
	$(MAKE) CONTENTS="$(EXTRA_ZIP)" -f Makefile-dist versionnedzips

#-ebuild $(TEXLIVE_OVERLAY_LOCATION)/app-text/texlive-core/texlive-core-$(TEXLIVE_VERSION).ebuild digest

ebuildsdir:
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/$(DESC:%=dev-texlive/%)

ebuilds: dist $(DESC:%=%.desc) $(DESC:%=%.ebuild) $(DESC:%=%.deps)

tlpobj: $(DESC:%=%.tlpobj)

tlpobj: $(DESC:%=%.tlplic)

licenselist: $(DESC:%=%.licenselist) $(EXTRA_DIST:%=%.licenselist)

gentoolicenses: $(DESC:%=%.gentoolicense) $(EXTRA_DIST:%=%.gentoolicense)

%.installed: %.ebuild %.metadata
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)
	$(CPF) $(@:%.installed=%.ebuild) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION)$(EXTRA_REV).ebuild
	$(CPF) $(@:%.installed=%.metadata) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/metadata.xml
	ebuild $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION)$(EXTRA_REV).ebuild digest
	echo "$(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION)$(EXTRA_REV).ebuild" > $@

ebuilds-install: $(DESC:%=%.installed)


texlive-core.gentoolicense: $(EXTRA_DIST:%=%.gentoolicense)
	cat $(EXTRA_DIST:%=%.gentoolicense) | tr ' ' '\n' | sort | uniq | tr '\n' ' ' > $@

ebuildsclean: clean
	$(RMF) $(DESC:%=%.ebuild)
	$(RMF) $(DESC:%=%.desc)
	$(RMF) $(DESC:%=%.installed)
	$(RMF) $(DESC:%=%.gentoolicense)

%.dotbase: %.deps
	sed -e "s/^/\"$(<:%.deps=%)\" -> \"/" $< | tr '\n' '#' | sed -e "s/#/\"#/g" | tr '#' '\n' | sed -e "s:dev-texlive/texlive-::g" | sed -e "s:texlive-::g" > $@


dot: $(DESC:%=%.dotbase)
	echo "digraph G{" > texlive-$(TEXLIVE_VERSION).dot
	cat $(DESC:%=%.dotbase) >>  texlive-$(TEXLIVE_VERSION).dot
	echo "}" >>  texlive-$(TEXLIVE_VERSION).dot
