#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GeoClue is a modularbr3ak geoinformation service built on top of the D-Bus messaging system. The goal of thebr3ak GeoClue project is to makebr3ak creating location-aware applications as simple as possible.br3ak"
SECTION="basicnet"
VERSION=2.4.12
NAME="geoclue2"

#REQ:json-glib
#REQ:libsoup
#REC:ModemManager
#REC:vala
#REC:avahi
#OPT:libnotify


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/geoclue/releases/2.4/geoclue-2.4.12.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/geoclue/releases/2.4/geoclue-2.4.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-2.4.12.tar.xz

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
