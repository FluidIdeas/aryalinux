#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=006-m4

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=m4-1.4.18.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

fi

cleanup $DIRECTORY
log $NAME