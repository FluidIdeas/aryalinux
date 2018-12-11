#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gtk-recordmydesktop"
VERSION="0.3.8"

#REQ:gtk2
#REC:recordmydesktop

cd $SOURCE_DIR

wget -c https://sourceforge.net/projects/recordmydesktop/files/gtk-recordMyDesktop/0.3.8/gtk-recordmydesktop-0.3.8.tar.gz/download -O gtk-recordmydesktop-0.3.8.tar.gz

TARBALL="gtk-recordmydesktop-0.3.8.tar.gz"
DIRECTORY="gtk-recordmydesktop-0.3.8"

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
