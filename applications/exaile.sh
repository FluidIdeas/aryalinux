#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="exaile"
VERSION="4.0.0"

NAME="exaile"

#REQ:gst-plugins-base
#REQ:gst-plugins-good
#REQ:gst-plugins-bad
#REQ:gst-plugins-ugly
#REQ:mutagen

cd $SOURCE_DIR
URL="https://github.com/exaile/exaile/releases/download/4.0.0-beta3/exaile-4.0.0beta3.tar.gz"
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
