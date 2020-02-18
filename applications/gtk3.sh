#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:at-spi2-atk
#REQ:fribidi
#REQ:gdk-pixbuf
#REQ:libepoxy
#REQ:pango
#REQ:adwaita-icon-theme
#REQ:hicolor-icon-theme
#REQ:iso-codes
#REQ:libxkbcommon
#REQ:sassc
#REQ:wayland
#REQ:wayland-protocols
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.13.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.13.tar.xz


NAME=gtk3
VERSION=3.24.13
URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.13.tar.xz
SECTION="X Libraries"
DESCRIPTION="The GTK+ 3 package contains libraries used for creating graphical user interfaces for applications."

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


mkdir build-gtk3 &&
cd    build-gtk3 &&

meson --prefix=/usr     \
      -Dcolord=yes      \
      -Dgtk_doc=false   \
      -Dman=true        \
      -Dbroadway_backend=true .. &&
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

