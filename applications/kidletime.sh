#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="kidletime"
VERSION="5.32.0"

#REQ:extra-cmake-modules

cd $SOURCE_DIR

URL=http://download.kde.org/stable/frameworks/5.32/kidletime-5.32.0.tar.xz

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
