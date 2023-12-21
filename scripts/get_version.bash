#!/usr/bin/env bash

tagInfo=$(git describe --tags --abbrev=0 2>/dev/null)

if [[ -z "$tagInfo" ]]
then
    git rev-parse --short HEAD > version.txt
else
    printf "%s" "$tagInfo" > version.txt
fi
