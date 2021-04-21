#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=011-file

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=file-5.39.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install
mv -v $LFS/usr/lib/libmagic.so.* $LFS/lib
ln -sfv ../../lib/$(readlink /usr/lib/libmagic.so) $LFS/usr/lib/libmagic.so

fi

cleanup $DIRECTORY
log $NAME