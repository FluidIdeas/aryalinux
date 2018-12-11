#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="recordmydesktop"
VERSION="0.3.8.1"

#REC:jack2
#REC:audio-video-libraries

cd $SOURCE_DIR

wget -c https://sourceforge.net/projects/recordmydesktop/files/recordmydesktop/0.3.8.1/recordmydesktop-0.3.8.1.tar.gz/download -O recordmydesktop-0.3.8.1.tar.gz

TARBALL="recordmydesktop-0.3.8.1.tar.gz"
DIRECTORY="recordmydesktop-0.3.8.1"

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --enable-jack=yes &&
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
