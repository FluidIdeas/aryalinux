#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=055-sed

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=sed-4.7.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
./configure --prefix=/usr --bindir=/bin
make
make html
make install
install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7

fi

cleanup $DIRECTORY
log $NAME