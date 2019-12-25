#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=076-openssl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=openssl-1.1.1c.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


ln -svf /tools/bin/env /usr/bin/
sed -i '/\} data/s/ =.*$/;\n    memset(\&data, 0, sizeof(data));/' \
  crypto/rand/rand_lib.c
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1c
cp -vfr doc/* /usr/share/doc/openssl-1.1.1c

fi

cleanup $DIRECTORY
log $NAME