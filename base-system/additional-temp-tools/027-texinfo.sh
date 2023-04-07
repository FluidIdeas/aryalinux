#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=027-texinfo

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=texinfo-7.0.3.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME