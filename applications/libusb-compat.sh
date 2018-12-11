#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libusb-compat package aims tobr3ak look, feel and behave exactly like libusb-0.1. It is a compatibility layer neededbr3ak by packages that have not been upgraded to the libusb-1.0 API.br3ak"
SECTION="general"
VERSION=0.1.5
NAME="libusb-compat"

#REQ:libusb


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
