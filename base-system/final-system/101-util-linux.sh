#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=101-util-linux

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=util-linux-2.34.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


mkdir -pv /var/lib/hwclock
rm -vf /usr/include/{blkid,libmount,uuid}
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.34 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python
make
make install

fi

cleanup $DIRECTORY
log $NAME