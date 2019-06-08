#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=bison

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=bison-3.3.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2
make
make install

fi

cleanup
log $NAME