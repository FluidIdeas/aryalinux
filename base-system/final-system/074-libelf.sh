#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=074-libelf

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=elfutils-0.176.tar.bz2
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig

fi

cleanup $DIRECTORY
log $NAME