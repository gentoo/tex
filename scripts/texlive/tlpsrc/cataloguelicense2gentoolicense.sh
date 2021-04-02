#!/bin/bash
while [ $# -gt 0 ] ; do
    case "$1" in
        cc-by-sa-2)
            echo "CC-BY-SA-2.0";;
        cc-by-sa-4)
            echo "CC-BY-SA-4.0";;
        gpl)
            echo "GPL-1";;
        gpl2)
            echo "GPL-2";;
        gpl2+)
            echo "GPL-2+";;
        gpl3)
            echo "GPL-3";;
        gpl3+)
            echo "GPL-3+";;
        gpl3+cc-by-sa-4)
            $0 gpl3+ cc-by-sa-4;;
        gplofllppl)
            $0 gpl ofl lppl;;
        lppl1)
            echo "LPPL-1.3";;
        lppl)
            echo "LPPL-1.3";;
        lppl1.2)
            echo "LPPL-1.2";;
        lppl1.3)
            echo "LPPL-1.3";;
        lppl1.3c)
            echo "LPPL-1.3c";;
        # Some tlpobj from texlive have this like that. This means both and are
        # only few of them, so split manually.
        lppl1.3ofl)
            $0 lppl1.3 ofl;;
        lppl1.3lppl1.3)
            $0 lppl1.3;;
        lpplgpl)
            $0 lppl gpl;;
        lpplgpl2)
            $0 lppl gpl2;;
        lppllppl)
            $0 lppl;;
        gfl)
            echo "LPPL-1.3";;
        gfsl)
            echo "LPPL-1.3";;
        #unknown)
        #    echo "TeX-unknown";;
        noinfo)
            echo "TeX-noinfo";;
        nosource)
            echo "TeX-nosource";;
        collection)
            echo "GPL-2";;
        other-free)
            echo "TeX-other-free";;
        other-freelppl)
            $0 other-free lppl;;
        other-freelppl1.3)
            $0 other-free lppl1.3;;
        #other)
        #    echo "TeX-other";;
        other-nonfree)
            echo "TeX-other-nonfree";;
        lgpl)
            echo "LGPL-2";;
        lgpl2.1)
            echo "LGPL-2.1";;
        lgpl3)
            echo "LGPL-3";;
        pd)
            echo "public-domain";;
        pdgpl3)
            $0 pd gpl3;;
        apache2)
            echo "Apache-2.0";;
        artistic2)
            echo "Artistic-2";;
        artistic)
            echo "Artistic";;
        bsd)
            echo "BSD";;
        bsd3)
            echo "BSD";;
        knuth)
            echo "TeX";;
        fdl)
            echo "FDL-1.1";;
        ofl)
            echo "OFL";;
        oflapache2lppl1.3)
            $0 ofl apache2 lppl1.3;;
        ofllppl)
            $0 ofl lppl;;
        ofllppl1.3)
            $0 ofl lppl1.3;;
        opl)
            echo "OPL";;
        mit)
            echo "MIT";;
        mitlppl)
            $0 mit lppl;;
        bsd2)
            echo "BSD-2";;
        #nosell)
        #    echo "nosell";;
        #nocommercial)
        #    echo "nosell";;
        *)
            echo "The $1 license is not mapped yet!"
            exit 1;;
    esac
    shift
done
