#!/bin/bash
while [ $# -gt 0 ] ; do
        grep docfile $1.tlpobj > /dev/null && echo -n "$1.doc "
    shift
done
