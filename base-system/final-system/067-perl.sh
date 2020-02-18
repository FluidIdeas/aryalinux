#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=067-perl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=perl-5.30.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
make
make install
unset BUILD_ZLIB BUILD_BZIP2

fi

cleanup $DIRECTORY
log $NAME