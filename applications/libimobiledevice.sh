#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libimobiledevice"
DESCRIPTION="A cross-platform software protocol library and tools to communicate with iOS® devices natively."
VERSION="1.2.0"

#REQ:libplist
#REQ:libusbmuxd

URL=http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/libimobiledevice-1.2.0-sslv3.patch 
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../libimobiledevice-1.2.0-sslv3.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
