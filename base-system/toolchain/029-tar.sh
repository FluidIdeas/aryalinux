#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=029-tar

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=tar-1.32.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools
make
make install

fi

cleanup $DIRECTORY
log $NAME