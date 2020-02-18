#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=012-ncurses

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=ncurses-6.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


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

cleanup $DIRECTORY
log $NAME