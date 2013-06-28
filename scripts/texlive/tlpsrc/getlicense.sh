#!/bin/bash
while [ $# -gt 0 ] ; do
    cat $1.cataloguehtml | tr '"' '\n' | grep '\/license\/' | tr '/' ' ' | awk '{print $2}'
    shift
done
