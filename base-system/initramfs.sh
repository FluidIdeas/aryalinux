#!/bin/bash

set -e
set +h

. /sources/build-properties

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.15.tar.bz2
cd cpio-2.15
# GCC 15 / C23: give function pointers explicit prototypes (cpio 2.15)
sed -i \
  -e 's/^extern int (\*xstat) ();$/extern int (*xstat) (const char *, struct stat *);/' \
  -e 's/^extern void (\*copy_function) ();$/extern void (*copy_function) (void);/' \
  src/extern.h
sed -i \
  -e 's/^int (\*xstat) ();$/int (*xstat) (const char *, struct stat *);/' \
  -e 's/^void (\*copy_function) () = 0;$/void (*copy_function) (void) = 0;/' \
  src/global.c
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

tar xf 110.tar.gz
cd dracut-ng-110
./configure --disable-documentation
make
make install
cd /sources
rm -rf dracut-ng-110

echo "initramfs" | tee -a /sources/build-log

fi
