#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

NAME=initramfs-003-dracut

touch /sources/build-log

cd /sources

TARBALL=110.tar.gz
DIRECTORY=dracut-110

if ! grep "$NAME" /sources/build-log; then

tar xf $TARBALL
cd $DIRECTORY

./configure --disable-documentation

make
make install

fi

cleanup $DIRECTORY
log $NAME
