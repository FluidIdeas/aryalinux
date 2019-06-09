#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=060-bash

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bash-5.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline
make
make install
mv -vf /usr/bin/bash /bin

fi

cleanup $DIRECTORY
log $NAME