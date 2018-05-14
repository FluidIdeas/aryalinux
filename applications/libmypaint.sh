#!/bin/bash

set -e
set +h

NAME="libmypaint"
VERSION="1.3.0"

#REQ:json-c

. /etc/alps/alps.conf
. /var/lib/alps/functions

URL=https://github.com/mypaint/libmypaint/releases/download/v1.3.0-beta.1/libmypaint-1.3.0-beta.1.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
