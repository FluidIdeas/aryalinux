#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=024-make

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=make-4.2.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/tools --without-guile
make
make install

fi

cleanup $DIRECTORY
log $NAME