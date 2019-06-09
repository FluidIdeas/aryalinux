#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=021-gettext

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gettext-0.20.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin

fi

cleanup $DIRECTORY
log $NAME