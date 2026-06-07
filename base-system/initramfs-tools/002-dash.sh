#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

NAME=initramfs-002-dash

touch /sources/build-log

cd /sources

TARBALL=dash-0.5.13.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

if ! grep "$NAME" /sources/build-log; then

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --enable-static

make
make install

fi

cleanup $DIRECTORY
log $NAME
