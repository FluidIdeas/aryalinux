#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libvdpau-va-gl"
DESCRIPTION=
VERSION=0.4.0

#REQ:cmake
#REQ:ffmpeg
#REQ:x7driver
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
