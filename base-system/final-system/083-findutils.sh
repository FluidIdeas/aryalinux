#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=083-findutils

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=findutils-4.8.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

fi

cleanup $DIRECTORY
log $NAME