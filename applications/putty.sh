#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="putty_.orig"
VERSION="0.67"

#REQ:gtk2

URL=http://archive.ubuntu.com/ubuntu/pool/universe/p/putty/putty_0.67.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

sudo tee /usr/share/applications/putty.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Putty SSH Client
Comment=Connect to remote client over SSH
GenericName=Putty Client
Exec=putty %u
Terminal=false
Type=Application
Icon=putty
Categories=System;GTK;Utility;
StartupNotify=true
EOF


cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
