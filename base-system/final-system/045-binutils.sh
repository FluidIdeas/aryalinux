#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=045-binutils

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=binutils-2.36.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
mkdir -v build
cd       build
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib
make tooldir=/usr
make tooldir=/usr install
rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a

fi

cleanup $DIRECTORY
log $NAME