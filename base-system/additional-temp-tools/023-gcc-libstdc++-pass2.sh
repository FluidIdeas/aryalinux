#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=023-gcc-libstdc++-pass2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


ln -svf gthr-posix.h libgcc/gthr-default.h
mkdir -v build
cd       build
../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch
make
make install

fi

cleanup $DIRECTORY
log $NAME