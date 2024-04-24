#!/usr/bin/env bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
PROJECTPATH="$(pwd)"

for BUILD in $(find $SCRIPTPATH -type f -name "*-build.sh"); do
    $BUILD
done
