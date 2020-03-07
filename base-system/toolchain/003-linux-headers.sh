#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=003-linux-headers

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=linux-5.5.7.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make mrproper
make headers
cp -rv usr/include/* /tools/include

fi

cleanup $DIRECTORY
log $NAME