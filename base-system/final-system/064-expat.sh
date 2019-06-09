#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=064-expat

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=expat-2.2.6.tar.bz2
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
make
make install
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6

fi

cleanup $DIRECTORY
log $NAME