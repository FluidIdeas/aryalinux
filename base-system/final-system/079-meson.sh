#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=079-meson

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=meson-0.51.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL "

python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /

fi

cleanup $DIRECTORY
log $NAME