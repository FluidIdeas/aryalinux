#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gnome-common"
VERSION="3.18.0"



cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/GNOME/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
