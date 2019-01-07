#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:caribou
#REQ:evolution-data-server
#REQ:gjs
#REQ:gnome-control-center
#REQ:libcroco
#REQ:mutter
#REQ:sassc
#REQ:startup-notification
#REQ:systemd
#REQ:adwaita-icon-theme
#REQ:dconf
#REQ:gdm
#REQ:gnome-backgrounds
#REQ:gnome-menus
#REQ:gnome-themes-extra
#REQ:telepathy-mission-control
#REC:gnome-bluetooth
#REC:gst10-plugins-base
#REC:network-manager-applet
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.28/gnome-shell-3.28.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.28/gnome-shell-3.28.3.tar.xz

NAME=gnome-shell
VERSION=3.28.3
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.28/gnome-shell-3.28.3.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir build &&
cd build &&

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
