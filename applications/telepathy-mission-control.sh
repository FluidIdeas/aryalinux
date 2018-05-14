#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Telepathy Mission Control is anbr3ak account manager and channel dispatcher for the Telepathy framework, allowing user interfacesbr3ak and other clients to share connections to real-time communicationbr3ak services without conflicting.br3ak"
SECTION="general"
VERSION=5.16.4
NAME="telepathy-mission-control"

#REQ:telepathy-glib
#REC:networkmanager
#OPT:gtk-doc
#OPT:upower


cd $SOURCE_DIR

URL=https://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz

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
