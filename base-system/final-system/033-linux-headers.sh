#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=033-linux-headers

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=linux-5.2.11.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include

fi

cleanup $DIRECTORY
log $NAME