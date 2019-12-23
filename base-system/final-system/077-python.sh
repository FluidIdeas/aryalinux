#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=077-python

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=Python-3.8.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make
make install
chmod -v 755 /usr/lib/libpython3.8.so
chmod -v 755 /usr/lib/libpython3.so
ln -sfv pip3.8 /usr/bin/pip3
install -v -dm755 /usr/share/doc/python-3.8.1/html 

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.8.1/html \
    -xvf ../python-3.8.1-docs-html.tar.bz2

fi

cleanup $DIRECTORY
log $NAME