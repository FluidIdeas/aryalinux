#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=073-libelf

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=elfutils-0.183.tar.bz2
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy \
            --libdir=/lib
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a

fi

cleanup $DIRECTORY
log $NAME