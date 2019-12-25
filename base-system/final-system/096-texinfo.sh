#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=096-texinfo

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=texinfo-6.6.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --disable-static
make
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd

fi

cleanup $DIRECTORY
log $NAME