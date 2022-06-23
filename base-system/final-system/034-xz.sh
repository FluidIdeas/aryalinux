#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=034-xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=xz-5.2.5.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


patch -Np1 -i ../xz-5.2.5-upstream_fix-1.patch
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5
make
make install

fi

cleanup $DIRECTORY
log $NAME