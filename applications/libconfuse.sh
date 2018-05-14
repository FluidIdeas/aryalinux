#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libconfuse"
DESCRIPTION="libConfuse is a configuration file parser library, licensed under the terms of the ISC license, and written in C"
VERSION="3.0"

cd $SOURCE_DIR

URL=https://github.com/martinh/libconfuse/releases/download/v3.0/confuse-3.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
./configure --prefix=/usr &&
make "-j$(nproc)"
sudo make install

cd $SOURCE_DIR
rm -r $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
