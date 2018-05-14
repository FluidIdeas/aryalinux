#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak OBEX Data Server package containsbr3ak D-Bus service providing high-level OBEX client and server sidebr3ak functionality.br3ak"
SECTION="general"
VERSION=0.4.6
NAME="obex-data-server"

#REQ:bluez
#REQ:dbus-glib
#REQ:imagemagick
#REQ:gdk-pixbuf
#REQ:libusb-compat
#REQ:openobex


cd $SOURCE_DIR

URL=http://tadas.dailyda.com/software/obex-data-server-0.4.6.tar.gz

if [ ! -z $URL ]
then
wget -nc http://tadas.dailyda.com/software/obex-data-server-0.4.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/8.2/obex-data-server-0.4.6-build-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/obex-data-server/obex-data-server-0.4.6-build-fixes-1.patch

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

patch -Np1 -i ../obex-data-server-0.4.6-build-fixes-1.patch &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
