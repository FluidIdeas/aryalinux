#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=009-expect

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=expect5.45.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include
make
make SCRIPTS="" install

fi

cleanup $DIRECTORY
log $NAME