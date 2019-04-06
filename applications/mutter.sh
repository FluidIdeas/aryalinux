#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clutter
#REQ:gnome-desktop
#REQ:libwacom
#REQ:libxkbcommon
#REQ:upower
#REQ:zenity
#REQ:libpipewire
#REC:gobject-introspection
#REC:libcanberra
#REC:startup-notification
#REC:libinput
#REC:wayland
#REC:wayland-protocols
#REC:xorg-server
#REC:gtk3

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/mutter/3.32/mutter-3.32.0.tar.xz

NAME=mutter
VERSION=3.32.0
URL=http://ftp.acc.umu.se/pub/gnome/sources/mutter/3.32/mutter-3.32.0.tar.xz

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

mkdir -pv build &&
cd build

meson --prefix=/usr &&
ninja
sudo ninja install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
