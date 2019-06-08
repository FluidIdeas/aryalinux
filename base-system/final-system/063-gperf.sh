#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=gperf

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=gperf-3.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make install

fi

cleanup
log $NAME