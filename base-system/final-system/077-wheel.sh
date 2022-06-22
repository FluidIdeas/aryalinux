#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=077-wheel

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=wheel-0.37.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 install --no-index $PWD

fi

cleanup $DIRECTORY
log $NAME