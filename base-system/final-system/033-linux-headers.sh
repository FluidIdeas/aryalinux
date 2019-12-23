#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=033-linux-headers

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=linux-5.4.6.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include/* /usr/include

fi

cleanup $DIRECTORY
log $NAME