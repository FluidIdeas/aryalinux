#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=076-python

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=Python-3.10.5.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --enable-optimizations
make
make install
sed -e '/def warn_if_run_as_root/a\    return' \
    -i /usr/lib/python3.10/site-packages/pip/_internal/cli/req_command.py
install -v -dm755 /usr/share/doc/python-3.10.5/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.10.5/html \
    -xvf ../python-3.10.5-docs-html.tar.bz2

fi

cleanup $DIRECTORY
log $NAME