#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=048-attr

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=attr-2.4.48.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48
make
make install
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

fi

cleanup $DIRECTORY
log $NAME