#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=bison

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=bison-3.4.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed -i '6855 s/mv/cp/' Makefile.in
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.4.1
make -j1
make install

fi

cleanup
log $NAME