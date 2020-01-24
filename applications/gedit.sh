#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:git
#REQ:gsettings-desktop-schemas
#REQ:gspell
#REQ:gtksourceview4
#REQ:itstool
#REQ:libpeas
#REQ:gvfs
#REQ:iso-codes
#REQ:libsoup
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gedit/3.32/gedit-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gedit/3.32/gedit-3.32.2.tar.xz


NAME=gedit
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/gedit/3.32/gedit-3.32.2.tar.xz
SECTION="Editors"
DESCRIPTION="The Gedit package contains a lightweight UTF-8 text editor for the GNOME Desktop."

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

meson --prefix=/usr -Dbuildtype=release .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

