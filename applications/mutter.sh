#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnome-desktop
#REQ:gnome-settings-daemon
#REQ:graphene
#REQ:libcanberra
#REQ:libwacom
#REQ:libxkbcommon
#REQ:pipewire
#REQ:upower
#REQ:zenity
#REQ:desktop-file-utils
#REQ:gobject-introspection
#REQ:startup-notification
#REQ:sysprof
#REQ:libinput
#REQ:wayland
#REQ:wayland-protocols
#REQ:xorg-server
#REQ:gtk3
#REQ:graphene
#REQ:pipewire


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/mutter/40/mutter-40.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/mutter/40/mutter-40.0.tar.xz


NAME=mutter
VERSION=40.0
URL=https://download.gnome.org/sources/mutter/40/mutter-40.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Mutter is the window manager for GNOME. It is not invoked directly, but from GNOME Session (on a machine with a hardware accelerated video driver)."

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


sed -i '/libmutter_dep = declare_dependency(/a sources: mutter_built_sources,' src/meson.build
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

