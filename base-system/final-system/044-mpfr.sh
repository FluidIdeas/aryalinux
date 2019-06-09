#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=mpfr

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=mpfr-4.0.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2
make
make html
make install
make install-html

fi

cleanup $DIRECTORY
log $NAME