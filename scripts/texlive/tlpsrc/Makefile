
include Makefile.common

include Makefile.def

VERSIONNED_ZIPS = $(DESC:%=%.versionnedzips) $(EXTRA_DIST:%=%.versionnedzips) $(DESC:%=%.docversionnedzips) $(EXTRA_DIST:%=%.docversionnedzips) $(DESC:%=%.srcversionnedzips) $(EXTRA_DIST:%=%.srcversionnedzips)

FULLDESC = $(DESC) $(EXTRA_DIST)

lists : $(FULLDESC:%=%.list) $(FULLDESC:%=%.base)

%.base: 
	$(CPF) $(@:texlive-%.base=$(TL_TRUNK)/Master/tlpkg/tlpsrc/collection-%.tlpsrc) $@

%.list: %.base
	grep "depend " $< | awk '{print $$2}'  > $@
	grep -v "collection" $@ > $@.temp
	tr '\n' ' ' < $@.temp > $@
	$(RMF) $@.temp
	-sh $(@:%.list=%.extraexec) $@
	echo "$(@:texlive-%.list=collection-%)" >> $@

%.doclist: %.tlpobj
	./gendoc.sh $(shell cat $(<:%.tlpobj=%.list)) > $@

%.srclist: %.tlpobj
	./gensrc.sh $(shell cat $(<:%.tlpobj=%.list)) > $@

%.licenselist: %.tlplic
	./getlicense.sh $(shell cat $(<:%.tlplic=%.list)) | sort | uniq | tr '\n' ' ' > $@

%.gentoolicense: %.licenselist
	./cataloguelicense2gentoolicense.sh $(shell cat $<) | sort | uniq | tr '\n' ' ' > $@

%.desc: %.base
	grep "shortdesc " $< | sed -e "s/shortdesc //" | sed -e "s/.*/DESCRIPTION=\"TeXLive \0\"/" > $@

%.metadata: %.base
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo '<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">' >> $@
	echo '<pkgmetadata>' >> $@
	echo '	<herd>tex</herd>' >> $@
	echo '	<maintainer>' >> $@
	echo '		<email>aballier@gentoo.org</email>' >> $@
	echo '		<name>Alexis Ballier</name>' >> $@
	echo '	</maintainer>' >> $@
	echo '<longdescription lang="en">' >> $@
	grep "longdesc " $< | sed -e "s/longdesc //" >> $@
	echo '</longdescription>' >> $@
	echo '</pkgmetadata>' >> $@

%.deps: %.base
	grep "depend " $< | awk '{print $$2}' > $@.temp
	-grep "collection" $@.temp > $@
	$(RMF) $@.temp
	sed -i -e "s/collection/texlive/g" $@
	sed -i -e "s/^/dev-texlive\//" $@
	sed -i -e "s/dev-texlive\/texlive-basicbin//g" $@
	sed -i -e "s/dev-texlive\/texlive-fontbin//g" $@
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
	$(RMF) $(DESC:%=%.dotbase)
	$(RMF) $(DESC:%=%.deps)
	$(RMF) $(DESC:%=%.metadata)
	$(RMF) *.tlpobj
	$(RMF) *.tlplic

%.versionnedzips: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.docversionnedzips: %.doclist
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.srcversionnedzips: %.srclist
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.tlpobj: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist tlpobj
	touch $@

%.tlplic: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist tlplic
	touch $@

%.ebuild: %.desc %.deps %.list %.doclist %.srclist %.gentoolicense
	cat $(PORTDIR)/header.txt > $@
	echo -n "TEXLIVE_MODULES_DEPS=\"" >> $@
	cat $(@:%.ebuild=%.deps) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.list) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_DOC_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.doclist) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_SRC_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.srclist) >> $@
	echo "\"" >> $@
	echo "inherit texlive-module" >> $@
	cat $< >> $@
	echo "" >> $@
	echo -n "LICENSE=\"" >> $@
	cat $(@:%.ebuild=%.gentoolicense) >> $@
	echo "\"" >> $@
	echo "SLOT=\"0\"" >> $@
	echo "KEYWORDS=\"~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd\"" >> $@
	echo "IUSE=\"\"" >> $@
	-test -f $(@:%.ebuild=%.extrardepend) && echo -n "RDEPEND=\"" >> $@ && cat $(@:%.ebuild=%.extrardepend) >> $@ && echo "\"" >> $@

dist: lists $(VERSIONNED_ZIPS)
	$(MAKE) CONTENTS="$(EXTRA_ZIP)" -f Makefile-dist versionnedzips
	-ebuild $(TEXLIVE_OVERLAY_LOCATION)/app-text/texlive-core/texlive-core-$(TEXLIVE_VERSION).ebuild digest

ebuildsdir:
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/$(DESC:%=dev-texlive/%)

ebuilds: dist $(DESC:%=%.desc) $(DESC:%=%.ebuild) $(DESC:%=%.deps)

tlpobj: $(DESC:%=%.tlpobj) 

tlpobj: $(DESC:%=%.tlplic) 

licenselist: $(DESC:%=%.licenselist) $(EXTRA_DIST:%=%.licenselist)

gentoolicenses: $(DESC:%=%.gentoolicense) $(EXTRA_DIST:%=%.gentoolicense)

%.installed: %.ebuild %.metadata
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)
	$(CPF) $(@:%.installed=%.ebuild) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild
	$(CPF) $(@:%.installed=%.metadata) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/metadata.xml
	ebuild $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild digest
	echo "$(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild" > $@

ebuilds-install: $(DESC:%=%.installed)

ebuildsclean: clean
	$(RMF) $(DESC:%=%.ebuild)
	$(RMF) $(DESC:%=%.desc)
	$(RMF) $(DESC:%=%.installed)

%.dotbase: %.deps
	sed -e "s/^/$(<:%.deps=%) -> /" $< > $@
	-sed -e "s/^/$(<:%.deps=%) -> /" $(<:%.deps=%.extradeps) >> $@
	sed -i -e "s:dev-texlive/texlive-::g" $@
	sed -i -e "s:texlive-::g" $@
	


dot: $(DESC:%=%.dotbase)
	echo "digraph G{" > texlive-$(TEXLIVE_VERSION).dot
	cat *dotbase >>  texlive-$(TEXLIVE_VERSION).dot
	echo "}" >>  texlive-$(TEXLIVE_VERSION).dot
