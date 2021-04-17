#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=078-meson

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=meson-0.57.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /

fi

cleanup $DIRECTORY
log $NAME