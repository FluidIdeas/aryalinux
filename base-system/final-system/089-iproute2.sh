#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=089-iproute2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=iproute2-5.4.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
make
make DOCDIR=/usr/share/doc/iproute2-5.4.0 install

fi

cleanup $DIRECTORY
log $NAME