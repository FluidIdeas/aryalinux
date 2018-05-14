#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Parole is a DVD/CD/music playerbr3ak for Xfce that uses GStreamer.br3ak"
SECTION="xfce"
VERSION=1.0.1
NAME="parole"

#REQ:gst10-plugins-base
#REQ:libxfce4ui
#REC:libnotify
#REC:taglib


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/parole/1.0/parole-1.0.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/apps/parole/1.0/parole-1.0.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/parole/parole-1.0.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/parole/parole-1.0.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/parole/parole-1.0.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/parole/parole-1.0.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/parole/parole-1.0.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/parole/parole-1.0.1.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
