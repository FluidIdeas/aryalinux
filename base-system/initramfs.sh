#!/bin/bash

set -e
set +h

. /sources/build-properties

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.15.tar.bz2
cd cpio-2.15
./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt
make
make install
cd /sources
rm -rf cpio-2.15

tar xf dash-0.5.13.1.tar.gz
cd dash-0.5.13.1
./configure --prefix=/usr --enable-static
make
make install
cd /sources
rm -rf dash-0.5.13.1

tar xf dracut-110.tar.xz
cd dracut-110
./configure --disable-documentation
make
make install
cd /sources
rm -rf dracut-110

echo "initramfs" | tee -a /sources/build-log

fi
