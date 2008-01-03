
include Makefile.common

include Makefile.def

VERSIONNED_ZIPS = $(DESC:%=%.versionnedzips) $(EXTRA_DIST:%=%.versionnedzips)

FULLDESC = $(DESC) $(EXTRA_DIST)

lists : $(FULLDESC:%=%.list) $(FULLDESC:%=%.base)

%.base: 
	$(CPF) $(@:texlive-%.base=$(TEXLIVE_INST_MOUNTPOINT)/texmf/lists/collection-%) $@

%.list: %.base
	grep "^+" $< > $@
	sed -i -e "s/+//" $@
	grep -v "collection" $@ > $@.temp
	tr '\n' ' ' < $@.temp > $@
	$(RMF) $@.temp
	sed -i -e "s/bin-xetex //" $@
	sed -i -e "s/bin-aleph //" $@
	sed -i -e "s/bin-omega //" $@
	sed -i -e "s/beamer //" $@
	sed -i -e "s/bin-xdvi //" $@
	sed -i -e "s/bin-dvipdfm //" $@
	-sh $(@:%.list=%.extraexec) $@
	echo "$(@:texlive-%.list=collection-%)" >> $@

%.desc: %.base
	grep "\*Title" $< > $@
	sed -i -e "s/\*Title: //" $@
	sed -i -e "s/.*/DESCRIPTION=\"TeXLive \0\"/" $@

%.deps: %.base
	grep "^+" $< > $@.temp
	sed -i -e "s/+//" $@.temp
	-grep "collection" $@.temp > $@
	$(RMF) $@.temp
	sed -i -e "s/collection/texlive/g" $@
	sed -i -e "s/^/dev-texlive\//" $@
	sed -i -e "s/dev-texlive\/texlive-basicbin//g" $@
	sed -i -e "s/dev-texlive\/texlive-binextra//g" $@
	sed -i -e "s/dev-texlive\/texlive-fontbin//g" $@
	-cat $(@:.deps=.extradeps) >> $@

clean:
	$(RMF) $(FULLDESC:%=%.list)
	$(RMF) $(FULLDESC:%=%.base)
	$(RMF) $(FULLDESC:%=%.versionnedzips)
	$(RMF) $(DESC:%=%.dotbase)
	$(RMF) $(DESC:%=%.deps)

%.versionnedzips: %.list
	$(MAKE) CONTENTS="$(shell cat $<)" -f Makefile-dist versionnedzips
	touch $@

%.ebuild: %.desc %.deps %.list
	cat $(PORTDIR)/header.txt > $@
	echo -n "TEXLIVE_MODULES_DEPS=\"" >> $@
	cat $(@:%.ebuild=%.deps) >> $@
	echo "\"" >> $@
	echo -n "TEXLIVE_MODULE_CONTENTS=\"" >> $@
	cat $(@:%.ebuild=%.list) >> $@
	echo "\"" >> $@
	echo "inherit texlive-module" >> $@
	cat $< >> $@
	echo "" >> $@
	echo -n "LICENSE=\"GPL-2 LPPL-1.3c" >> $@
	-test -f $(@:%.ebuild=%.extralicense) && cat $(@:%.ebuild=%.extralicense) >> $@
	echo "\"" >> $@
	echo "SLOT=\"0\"" >> $@
	echo "KEYWORDS=\"~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86\"" >> $@
	-test -f $(@:%.ebuild=%.extrardepend) && echo -n "RDEPEND=\"" >> $@ && cat $(@:%.ebuild=%.extrardepend) >> $@ && echo "\"" >> $@

dist: lists $(VERSIONNED_ZIPS)
	$(MAKE) CONTENTS="$(EXTRA_ZIP)" -f Makefile-dist versionnedzips
	$(CPF) $(TEXLIVE_LIVE_MOUNTPOINT)/source/source.tar.bz2 $(DISTDIR)/texlive-core-$(TEXLIVE_VERSION).tar.bz2
	-ebuild $(TEXLIVE_OVERLAY_LOCATION)/app-text/texlive-core/texlive-core-$(TEXLIVE_VERSION).ebuild digest

ebuildsdir:
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/$(DESC:%=dev-texlive/%)

ebuilds: dist $(DESC:%=%.desc) $(DESC:%=%.ebuild) $(DESC:%=%.deps)

%.installed: %.ebuild
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)
	$(CPF) $< $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild
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
