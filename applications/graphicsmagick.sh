#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

URL=https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/1.3.24/GraphicsMagick-1.3.24.tar.xz/download
cd $SOURCE_DIR

wget -nc $URL -O GraphicsMagick-1.3.24.tar.xz
TARBALL=GraphicsMagick-1.3.24.tar.xz
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-quantum-depth=16 --enable-shared --without-lcms &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
