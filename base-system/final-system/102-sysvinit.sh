#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=102-sysvinit

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=sysvinit-2.95.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


patch -Np1 -i ../sysvinit-2.95-consolidated-1.patch
make
make install

fi

cleanup $DIRECTORY
log $NAME