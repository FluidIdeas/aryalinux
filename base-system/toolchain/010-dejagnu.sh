#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=010-dejagnu

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=dejagnu-1.6.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools
make install

fi

cleanup $DIRECTORY
log $NAME