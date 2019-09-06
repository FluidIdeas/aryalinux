#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=015-bzip2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bzip2-1.0.8.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make
make PREFIX=/tools install

fi

cleanup $DIRECTORY
log $NAME