#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gstreamer-0.10"
VERSION="0.10.36"

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/gstreamer0.10_0.10.36.orig.tar.bz2"
wget -nc $URL
wget -nc https://github.com/Metrological/buildroot/raw/master/package/gstreamer/gstreamer/gstreamer-01-bison3.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../gstreamer-01-bison3.patch
./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
