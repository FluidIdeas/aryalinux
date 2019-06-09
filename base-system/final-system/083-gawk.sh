#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=gawk

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gawk-5.0.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install
mkdir -v /usr/share/doc/gawk-5.0.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.0.0

fi

cleanup
log $NAME