#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libXau package contains abr3ak library implementing the X11 Authorization Protocol. This is usefulbr3ak for restricting client access to the display.br3ak"
SECTION="x"
VERSION=1.0.8
NAME="libXau"

#REQ:xorgproto


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
