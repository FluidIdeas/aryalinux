#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="fldigi"
VERSION="3.23.13"

#REC:hamlib
#REC:flxmlrpc


cd $SOURCE_DIR

wget -c https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-3.23.13.tar.gz/download -O fldigi-3.23.13.tar.gz

TARBALL="fldigi-3.23.13.tar.gz"
DIRECTORY="fldigi-3.23.13"

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
