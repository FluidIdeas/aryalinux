#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=029-tar

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=tar-1.32.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "

./configure --prefix=/tools
make
make install

fi

cleanup $DIRECTORY
log $NAME