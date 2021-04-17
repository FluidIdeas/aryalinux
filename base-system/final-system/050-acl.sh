#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=050-acl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=acl-2.2.53.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53
make
make install
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

fi

cleanup $DIRECTORY
log $NAME