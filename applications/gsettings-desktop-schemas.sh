#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GSettings Desktop Schemasbr3ak package contains a collection of GSettings schemas for settingsbr3ak shared by various components of a GNOME Desktop.br3ak"
SECTION="gnome"
VERSION=3.28.0
NAME="gsettings-desktop-schemas"

#REQ:glib2
#REC:gobject-introspection


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.0.tar.xz

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

sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
