#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Telepathy Logger package is abr3ak headless observer client that logs information received by thebr3ak Telepathy framework. It featuresbr3ak pluggable backends to log different sorts of messages in differentbr3ak formats.br3ak"
SECTION="general"
VERSION=0.8.2
NAME="telepathy-logger"

#REQ:sqlite
#REQ:telepathy-glib
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2

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

sed 's@/apps/@/org/freedesktop/@' \
    -i data/org.freedesktop.Telepathy.Logger.gschema.xml.in


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
