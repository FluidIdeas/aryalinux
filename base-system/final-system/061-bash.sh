#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=061-bash

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bash-5.1.8.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                      \
            --docdir=/usr/share/doc/bash-5.1.8 \
            --without-bash-malloc              \
            --with-installed-readline
make
make install
exec /usr/bin/bash --login +h

fi

cleanup $DIRECTORY
log $NAME