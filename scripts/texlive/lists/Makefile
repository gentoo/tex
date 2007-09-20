
PORTDIR=$(shell portageq portdir)
DISTDIR=$(shell portageq distdir)

TEXLIVE_VERSION=2007

TEXLIVE_OVERLAY_LOCATION=../../../texlive-overlay

TEXLIVE_LIVE_MOUNTPOINT=/mnt/texlive-live
TEXLIVE_INST_MOUNTPOINT=/mnt/texlive-inst

MKDIRP=mkdir -p
RMF=rm -f
RMDIR=rmdir
CPF=cp -f

include Makefile.def

TARBALLS = $(DESC:%=dist/%-$(TEXLIVE_VERSION).tar.bz2) $(EXTRA_DIST:%=dist/%-$(TEXLIVE_VERSION).tar.bz2)

lists : $(DESC:%=%.list) $(DESC:%=%.base)

%.base: 
	$(CPF) $(@:texlive-%.base=$(TEXLIVE_INST_MOUNTPOINT)/texmf/lists/collection-%) $@

%.list: %.base
	grep "^+" $< > $@
	sed -i -e "s/+//" $@
	grep -v "collection" $@ > $@.temp
	tr '\n' ' ' < $@.temp > $@
	$(RMF) $@.temp
	sed -i -e "s/pgf //" $@
	sed -i -e "s/bin-xetex //" $@
	sed -i -e "s/bin-aleph //" $@
	sed -i -e "s/bin-omega //" $@
	sed -i -e "s/xcolor //" $@
	sed -i -e "s/beamer //" $@
	sed -i -e "s/bin-xdvi //" $@
	sed -i -e "s/bin-dvipdfm //" $@

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
	-cat $(@:.deps=.extradeps) >> $@

clean:
	$(RMF) $(DESC:%=%.list)
	$(RMF) $(DESC:%=%.deps)
	$(RMF) $(DESC:%=%.base)

dist/%-$(TEXLIVE_VERSION).tar.bz2: %.list
	echo "TEXLIVE_INST_MOUNTPOINT=$(TEXLIVE_INST_MOUNTPOINT)" > dist/Makefile
	echo -n "ZIP=" >> dist/Makefile
	cat $(@:dist/%-$(TEXLIVE_VERSION).tar.bz2=%.list) >> dist/Makefile
	echo "" >> dist/Makefile
	echo "include ../Makefile-dist.ref" >> dist/Makefile
	echo "all: $(@:dist/%=%)" >> dist/Makefile
	$(MAKE) -C dist
	$(RMF) dist/Makefile
	$(CPF) $@ $(DISTDIR)/

%.ebuild: %.desc %.deps
	cat $(PORTDIR)/header.txt > $@
	echo -n "TEXLIVE_MODULES_DEPS=\"" >> $@
	cat $(@:%.ebuild=%.deps) >> $@
	echo "\"" >> $@
	echo "inherit texlive-module" >> $@
	cat $< >> $@
	echo "" >> $@
	echo "LICENSE=\"GPL-2\"" >> $@
	echo "SLOT=\"0\"" >> $@
	echo "KEYWORDS=\"~amd64 ~x86\"" >> $@

dirs:
	$(MKDIRP) dist
	$(MKDIRP) dist/archive


dist: lists dirs $(TARBALLS)
	$(CPF) $(TEXLIVE_LIVE_MOUNTPOINT)/source/source.tar.bz2 $(DISTDIR)/texlive-core-$(TEXLIVE_VERSION).tar.bz2
	ebuild $(TEXLIVE_OVERLAY_LOCATION)/app-text/texlive-core/texlive-core-$(TEXLIVE_VERSION).ebuild digest

ebuildsdir:
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/$(DESC:%=dev-texlive/%)

ebuilds: dist $(DESC:%=%.desc) $(DESC:%=%.ebuild) $(DESC:%=%.deps)

%.installed: %.ebuild
	$(MKDIRP) $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)
	$(CPF) $< $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild
	ebuild $(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild digest
	echo "$(TEXLIVE_OVERLAY_LOCATION)/dev-texlive/$(@:%.installed=%)/$(@:%.installed=%)-$(TEXLIVE_VERSION).ebuild" > $@

ebuilds-install: $(DESC:%=%.installed)

distclean: clean
	$(RMF) $(TARBALLS)
	$(RMF) $(TARBALLS:%.tar.bz2=%/*)
	$(RMDIR) $(TARBALLS:%.tar.bz2=%)

ebuildsclean: clean
	$(RMF) $(DESC:%=%.ebuild)
	$(RMF) $(DESC:%=%.desc)
	$(RMF) $(DESC:%=%.installed)

fulldistclean: distclean
	$(RMF) dist/archive/*
	$(RMDIR) dist/archive
	$(RMDIR) dist


