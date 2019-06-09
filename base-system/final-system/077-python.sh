#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=Python

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=Python-3.7.3.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make
make install
chmod -v 755 /usr/lib/libpython3.7m.so
chmod -v 755 /usr/lib/libpython3.so
ln -sfv pip3.7 /usr/bin/pip3
install -v -dm755 /usr/share/doc/python-3.7.3/html 

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.7.3/html \
    -xvf ../python-3.7.3-docs-html.tar.bz2

fi

cleanup
log $NAME