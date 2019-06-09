#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=ncurses

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=ncurses-6.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

sed -i s/mawk// configure
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
make
make install
ln -s libncursesw.so /tools/lib/libncurses.so

fi

cleanup
log $NAME