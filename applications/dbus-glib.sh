#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The D-Bus GLib package containsbr3ak GLib interfaces to thebr3ak D-Bus API.br3ak"
SECTION="general"
VERSION=0.110
NAME="dbus-glib"

#REQ:dbus
#REQ:glib2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz

if [ ! -z $URL ]
then
wget -nc https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.110.tar.gz

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
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
