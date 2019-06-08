#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=libelf

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=elfutils-0.176.tar.bz2
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig

fi

cleanup
log $NAME