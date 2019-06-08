#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=autoconf

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=autoconf-2.69.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed '361 s/{/\\{/' -i bin/autoscan.in
./configure --prefix=/usr
make
make install

fi

cleanup
log $NAME