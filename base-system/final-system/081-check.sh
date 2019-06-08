#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=check

if ! grep "$NAME" /sources/build-log; then

cd $SOURCE_DIR

TARBALL=check-0.12.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr
make
make install
sed -i '1 s/tools/usr/' /usr/bin/checkmk

fi

cleanup
log $NAME