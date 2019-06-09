#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=man-pages

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=man-pages-5.01.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

make install

fi

cleanup
log $NAME