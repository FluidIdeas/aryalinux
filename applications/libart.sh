#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libart"
DESCRIPTION="Libart is a free software graphics library with a vector-based API."
VERSION="2.3.21"

cd $SOURCE_DIR

URL="http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
