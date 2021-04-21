#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gdk-pixbuf
#REQ:x7lib


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/gdk-pixbuf-xlib/gdk-pixbuf-xlib-3116b8ae.tar.xz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/gdk-pixbuf-xlib/gdk-pixbuf-xlib-3116b8ae.tar.xz


NAME=gdk-pixbuf-xlib
VERSION=311
URL=http://anduin.linuxfromscratch.org/BLFS/gdk-pixbuf-xlib/gdk-pixbuf-xlib-3116b8ae.tar.xz
SECTION="X Libraries"
DESCRIPTION="The gdk-pixbuf-xlib package provides a deprecated Xlib interface to gdk-pixbuf, which is needed for some applications which have not been ported to use the new interfaces yet."

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
