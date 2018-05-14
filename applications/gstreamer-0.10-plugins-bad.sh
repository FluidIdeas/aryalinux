#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gstreamer-0.10-plugins-bad"
VERSION="0.10.23"

#REQ:gstreamer-0.10

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gst-plugins-bad0.10/gst-plugins-bad0.10_0.10.23.orig.tar.bz2"
wget -nc $URL
wget -nc https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-bad/buffer-overflow-mp4.patch
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-plugins-bad/0003-drop-buggy-libvpx-legacy-handling.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../buffer-overflow-mp4.patch
patch -Np1 -i ../0003-drop-buggy-libvpx-legacy-handling.patch
./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
