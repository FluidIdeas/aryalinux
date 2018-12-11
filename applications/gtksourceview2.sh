#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gtksourceview"
VERSION="2.10.5"

#REQ:gtksourceview

cd $SOURCE_DIR

URL="http://ftp.gnome.org/pub/gnome/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
