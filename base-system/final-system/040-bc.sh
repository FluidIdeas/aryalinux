#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=040-bc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bc-3.3.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


PREFIX=/usr CC=gcc ./configure.sh -G -O3
make
make install

fi

cleanup $DIRECTORY
log $NAME