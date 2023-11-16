#!/usr/bin/env bash

tagInfo=$(git describe --tags --abbrev=0 2>/dev/null)

if [[ -z "$tagInfo" ]]
then
    git rev-parse --short HEAD > version.txt
else
    print "$tagInfo" > version.txt
fi
