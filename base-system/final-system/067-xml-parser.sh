#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=xml-parser

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=XML-Parser-2.44.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

perl Makefile.PL
make
make install

fi

cleanup
log $NAME