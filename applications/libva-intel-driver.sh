#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="libva-intel-driver"
VERSION="1.7.3"

#REQ:mesa
#OPT:doxygen
#OPT:wayland

cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.7.3.tar.bz2

wget -nc $URL
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/e4de7d482d444bcb77964cfc1fbcb0a67d1e31d5/libva-intel-driver-1.7.3-i965_drv_video.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../libva-intel-driver-1.7.3-i965_drv_video.patch
autoreconf -fi           &&
./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
