#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=065-expat

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=expat-2.2.9.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.9
make
make install
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.9

fi

cleanup $DIRECTORY
log $NAME