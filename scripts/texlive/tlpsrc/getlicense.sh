#!/bin/bash
while [ $# -gt 0 ] ; do
        grep -- catalogue-license $1.tlpobj | awk '{print $2}'
    shift
done
