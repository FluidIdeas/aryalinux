#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

NAME=092-grub

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=grub-2.14.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY
unset {C,CPP,CXX,LD}FLAGS

sed 's/--image-base/--nonexist-linker-option/' -i configure

if [ "$(uname -m)" = "x86_64" ]; then
./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-efiemu    \
            --with-platform=efi \
            --target=x86_64     \
            --disable-werror

make
make install
make clean
fi

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror

make

make install

fi

cleanup $DIRECTORY
log $NAME
