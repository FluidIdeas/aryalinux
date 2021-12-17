#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=102-util-linux

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=util-linux-2.37.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.37.2 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run
make
rm tests/ts/lsns/ioctl_ns
make install

fi

cleanup $DIRECTORY
log $NAME