#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=043-gmp

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gmp-6.1.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

ABI=32 ./configure ...
cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
make
make html
make install
make install-html

fi

cleanup $DIRECTORY
log $NAME