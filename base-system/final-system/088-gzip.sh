#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=088-gzip

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gzip-1.10.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
mv -v /usr/bin/gzip /bin

fi

cleanup $DIRECTORY
log $NAME