#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=groff

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=groff-1.22.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

PAGE=<paper_size> ./configure --prefix=/usr
make -j1
make install

fi

cleanup $DIRECTORY
log $NAME