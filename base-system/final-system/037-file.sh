#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=037-file

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=file-5.39.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
mv -v /usr/lib/libmagic.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libmagic.so) /usr/lib/libmagic.so

fi

cleanup $DIRECTORY
log $NAME