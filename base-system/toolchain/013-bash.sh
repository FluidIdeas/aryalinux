#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=013-bash

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bash-5.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools --without-bash-malloc
make
make install
ln -sv bash /tools/bin/sh

fi

cleanup $DIRECTORY
log $NAME