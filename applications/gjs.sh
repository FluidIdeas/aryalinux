#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cairo
#REQ:dbus
#REQ:gobject-introspection
#REQ:js78
#REQ:gtk3
#REQ:gtk4


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gjs/1.68/gjs-1.68.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gjs/1.68/gjs-1.68.0.tar.xz


NAME=gjs
VERSION=1.68.0
URL=https://download.gnome.org/sources/gjs/1.68/gjs-1.68.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Gjs is a set of Javascript bindings for GNOME."

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


mkdir gjs-build &&
cd    gjs-build &&

meson --prefix=/usr .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
ln -sfv gjs-console /usr/bin/gjs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

