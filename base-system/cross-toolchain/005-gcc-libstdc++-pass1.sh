#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=005-gcc-libstdc++-pass1

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


mkdir -v build
cd       build
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/10.2.0
make
make DESTDIR=$LFS install

fi

cleanup $DIRECTORY
log $NAME