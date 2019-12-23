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


make -f Makefile-libbz2_so
make clean
make
make PREFIX=/tools install
cp -v bzip2-shared /tools/bin/bzip2
cp -av libbz2.so* /tools/lib
ln -sv libbz2.so.1.0 /tools/lib/libbz2.so

fi

cleanup $DIRECTORY
log $NAME