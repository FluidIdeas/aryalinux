#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libsass
DESCRIPTION="A C/C++ implementation of a Sass compiler"
VERSION=3.5.2

URL=https://github.com/sass/libsass/archive/3.5.2/libsass-3.5.2.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

autoreconf -fi &&

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf libsass-3.5.2

echo "libsass=>$(date)" | sudo tee -a /etc/alps/installed-list
echo "libsass:$VERSION" | sudo tee -a /etc/alps/versions
