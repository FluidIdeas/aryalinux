#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=094-man-db

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=man-db-2.9.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/find/s@/usr@@' init/systemd/man-db.service.in

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.0 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap
make
make install

fi

cleanup $DIRECTORY
log $NAME