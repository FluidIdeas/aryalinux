#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="exaile"
VERSION="3.4.5"

NAME="exaile"

#REQ:gstreamer-0.10
#REQ:gstreamer-0.10-plugins-base
#REQ:gstreamer-0.10-plugins-good
#REQ:gstreamer-0.10-plugins-bad
#REQ:gstreamer-0.10-plugins-ugly
#REQ:gstreamer-0.10-ffmpeg
#REQ:mutagen
#REQ:gstreamer-0.10-python

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/e/exaile/exaile_3.4.5.orig.tar.gz"
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed -i "s@/usr/local@/usr@g" Makefile
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
