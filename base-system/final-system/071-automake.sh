#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=071-automake

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=automake-1.16.3.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i "s/''/etags/" t/tags-lisp-space.sh
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.3
make
make install

fi

cleanup $DIRECTORY
log $NAME