#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=082-gawk

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gawk-5.1.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install
mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0

fi

cleanup $DIRECTORY
log $NAME