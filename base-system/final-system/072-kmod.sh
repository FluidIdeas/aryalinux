#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=072-kmod

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=kmod-28.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make
make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod

fi

cleanup $DIRECTORY
log $NAME