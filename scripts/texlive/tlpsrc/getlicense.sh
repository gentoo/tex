#!/bin/bash
while [ $# -gt 0 ] ; do
        grep -- catalogue-license $1.tlplic | awk '{print $2}'
    shift
done
