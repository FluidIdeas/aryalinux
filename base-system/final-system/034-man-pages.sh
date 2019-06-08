#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=man-pages

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=man-pages-5.00.tar.xz
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