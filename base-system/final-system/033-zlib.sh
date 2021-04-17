#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=033-zlib

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=zlib-1.2.11.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
rm -fv /usr/lib/libz.a

fi

cleanup $DIRECTORY
log $NAME