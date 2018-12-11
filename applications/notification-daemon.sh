#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Notification Daemon packagebr3ak contains a daemon that displays passive pop-up notifications.br3ak"
SECTION="gnome"
VERSION=3.20.0
NAME="notification-daemon"

#REQ:gtk3
#REQ:libcanberra


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
