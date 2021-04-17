#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=061-bash

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bash-5.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i  '/^bashline.o:.*shmbchar.h/a bashline.o: ${DEFDIR}/builtext.h' Makefile.in
./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.1 \
            --without-bash-malloc            \
            --with-installed-readline
make
chown -Rv tester .
make install
mv -vf /usr/bin/bash /bin

fi

cleanup $DIRECTORY
log $NAME