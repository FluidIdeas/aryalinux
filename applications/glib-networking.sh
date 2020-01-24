#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REQ:make-ca


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.3.tar.xz


NAME=glib-networking
VERSION=2.60.3
URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.3.tar.xz
SECTION="Networking"
DESCRIPTION="The GLib Networking package contains Network related gio modules for GLib."

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

meson --prefix=/usr          \
      -Dlibproxy=disabled .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

