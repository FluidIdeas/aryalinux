#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="flxmlrpc"
VERSION="0.1.4"

#REC:hamlib


cd $SOURCE_DIR

wget -nc http://archive.ubuntu.com/ubuntu/pool/universe/f/flxmlrpc/flxmlrpc_0.1.4.orig.tar.gz

TARBALL="flxmlrpc_0.1.4.orig.tar.gz"
DIRECTORY="flxmlrpc-0.1.4"

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
