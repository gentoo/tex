#!/bin/bash
while [ $# -gt 0 ] ; do
    grep srcfiles $1.tlpobj > /dev/null && echo -n "$1.source "
    shift
done
