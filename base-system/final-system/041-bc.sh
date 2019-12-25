#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=041-bc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bc-2.1.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
make
make install

fi

cleanup $DIRECTORY
log $NAME