#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=Python

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=Python-3.7.3.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed -i '/def add_multiarch_paths/a \        return' setup.py
./configure --prefix=/tools --without-ensurepip
make
make install

fi

cleanup
log $NAME