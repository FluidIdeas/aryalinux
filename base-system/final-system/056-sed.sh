#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=056-sed

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=sed-4.8.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --bindir=/bin
make
make html
make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

fi

cleanup $DIRECTORY
log $NAME