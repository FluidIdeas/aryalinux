#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=087-less

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=less-551.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "

./configure --prefix=/usr --sysconfdir=/etc
make
make install

fi

cleanup $DIRECTORY
log $NAME