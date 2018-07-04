#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=flatpak
URL=http://aryalinux.com/files/sources/flatpak-0.11.7.tar.xz
VERSION=0.11.7

#REQ:libostree
#REQ:appstream-glib

cd $SOURCE_DIR
wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make -j$(nproc)
sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
