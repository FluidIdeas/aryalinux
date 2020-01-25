#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.60/gobject-introspection-1.60.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.60/gobject-introspection-1.60.2.tar.xz


NAME=gobject-introspection
VERSION=1.60.2
URL=http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.60/gobject-introspection-1.60.2.tar.xz
SECTION="General Libraries"
DESCRIPTION="The GObject Introspection is used to describe the program APIs and collect them in a uniform, machine readable format."

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

meson --prefix=/usr .. &&
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

