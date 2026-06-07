#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

NAME=initramfs-001-cpio

touch /sources/build-log

cd /sources

TARBALL=cpio-2.15.tar.bz2
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

if ! grep "$NAME" /sources/build-log; then

tar xf $TARBALL
cd $DIRECTORY

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

fi

cleanup $DIRECTORY
log $NAME
