#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=034-man-pages

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=man-pages-5.03.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make install

fi

cleanup $DIRECTORY
log $NAME