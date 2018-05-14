#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libsass

NAME=sassc
DESCRIPTION="libsass command line driver"
VERSION=3.5.0

URL=https://github.com/sass/sassc/archive/3.5.0/sassc-3.5.0.tar.gz

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://github.com/sass/libsass/archive/3.5.2/libsass-3.5.2.tar.gz

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

autoreconf -fi &&
./configure --prefix=/usr --disable-static &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf sassc-3.5.0

echo "sassc=>$(date)" | sudo tee -a /etc/alps/installed-list
echo "sassc:$VERSION" | sudo tee -a /etc/alps/versions
