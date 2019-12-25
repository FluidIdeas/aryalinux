#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=058-flex

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=flex-2.6.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
make
make install
ln -sv flex /usr/bin/lex

fi

cleanup $DIRECTORY
log $NAME