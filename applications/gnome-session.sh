#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Session package containsbr3ak the GNOME session manager.br3ak"
SECTION="gnome"
VERSION=3.28.1
NAME="gnome-session"

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:upower
#REQ:systemd
#OPT:GConf
#OPT:xmlto
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.28/gnome-session-3.28.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.28/gnome-session-3.28.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.28.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-session/3.28/gnome-session-3.28.1.tar.xz

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

sed 's@/bin/sh@/bin/sh -l@' -i gnome-session/gnome-session.in


mkdir build &&
cd    build &&
meson --prefix=/usr .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
