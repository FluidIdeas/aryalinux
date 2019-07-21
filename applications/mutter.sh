#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clutter
#REQ:gnome-desktop
#REQ:libcanberra
#REQ:libwacom
#REQ:libxkbcommon
#REQ:pipewire
#REQ:upower
#REQ:zenity
#REQ:gobject-introspection
#REQ:startup-notification
#REQ:libinput
#REQ:wayland
#REQ:wayland-protocols
#REQ:xorg-server
#REQ:gtk3


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/mutter/3.32/mutter-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/mutter/3.32/mutter-3.32.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/mutter-3.32.2-upstream_fixes-1.patch


NAME=mutter
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/mutter/3.32/mutter-3.32.2.tar.xz

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


patch -Np1 -i ../mutter-3.32.2-upstream_fixes-1.patch
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

