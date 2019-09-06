#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=031-xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=xz-5.2.4.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools
make
make install

fi

cleanup $DIRECTORY
log $NAME