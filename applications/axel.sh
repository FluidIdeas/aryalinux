#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=axel
DESCRIPTION="axel is a download accelerator that works by downloading parts of files using different threads"
VERSION=2.16.1
URL=https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.bz2

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
