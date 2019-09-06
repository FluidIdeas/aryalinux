#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=032-stripping

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man,doc}
find /tools/{lib,libexec} -name \*.la -delete

fi

cleanup $DIRECTORY
log $NAME