#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=070-autoconf

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=autoconf-2.69.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed '361 s/{/\\{/' -i bin/autoscan.in
./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME