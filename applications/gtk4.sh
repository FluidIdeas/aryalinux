#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fribidi
#REQ:gdk-pixbuf
#REQ:graphene
#REQ:iso-codes
#REQ:libepoxy
#REQ:libxkbcommon
#REQ:pango
#REQ:wayland-protocols
#REQ:adwaita-icon-theme
#REQ:ffmpeg
#REQ:gst10-plugins-bad
#REQ:hicolor-icon-theme
#REQ:librsvg
#REQ:gobject-introspection


cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc https://download.gnome.org/sources/gtk/4.2/gtk-4.2.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtk/4.2/gtk-4.2.0.tar.xz


NAME=gtk4
VERSION=4.2.0
URL=https://download.gnome.org/sources/gtk/4.2/gtk-4.2.0.tar.xz
SECTION="X Libraries"
DESCRIPTION="The GTK 4 package contains libraries used for creating graphical user interfaces for applications."

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

meson --prefix=/usr -Dbroadway_backend=true .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir -pv ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = oxygen
gtk-font-name = DejaVu Sans 12
gtk-cutsor-theme-size = 18
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-cursor-theme-name = Adwaita
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd