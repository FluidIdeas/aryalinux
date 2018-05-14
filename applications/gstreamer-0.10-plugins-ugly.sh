#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gstreamer-0.10-plugins-ugly"
VERSION="0.10.19"

#REQ:gstreamer-0.10

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gst-plugins-ugly0.10/gst-plugins-ugly0.10_0.10.19.orig.tar.bz2"
wget -nc $URL
wget -nc "https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-ugly/0001-cdio-compensate-for-libcdio-s-recent-cd-text-api-cha.patch"
wget -nc "https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-ugly/0002-Fix-opencore-include-paths.patch"

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../"0001-cdio-compensate-for-libcdio-s-recent-cd-text-api-cha.patch"
patch -Np1 -i ../"0002-Fix-opencore-include-paths.patch"

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
