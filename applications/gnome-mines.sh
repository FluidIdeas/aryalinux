#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libgee
#REQ:gtk3
#REQ:librsvg
#REQ:gsettings-desktop-schemas
#REQ:appstream-glib
#REQ:libgnome-games-support


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/GNOME/sources/gnome-mines/3.36/gnome-mines-3.36.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/GNOME/sources/gnome-mines/3.36/gnome-mines-3.36.0.tar.xz


NAME=gnome-mines
VERSION=3.36.0
URL=http://ftp.gnome.org/pub/GNOME/sources/gnome-mines/3.36/gnome-mines-3.36.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Mines is a puzzle game where you locate mines floating in an ocean using only your brain and a little bit of luck."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

meson --prefix=/usr      \
      --sysconfdir=/etc  \
      .. &&

ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

