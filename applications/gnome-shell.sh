#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:evolution-data-server
#REQ:gjs
#REQ:gnome-control-center
#REQ:libcroco
#REQ:mutter
#REQ:sassc
#REQ:startup-notification
#REQ:systemd
#REQ:gnome-bluetooth
#REQ:gst10-plugins-base
#REQ:network-manager-applet
#REQ:adwaita-icon-theme
#REQ:dconf
#REQ:gdm
#REQ:gnome-backgrounds
#REQ:gnome-menus
#REQ:gnome-themes-extra
#REQ:telepathy-mission-control


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.32/gnome-shell-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.32/gnome-shell-3.32.2.tar.xz


NAME=gnome-shell
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.32/gnome-shell-3.32.2.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Shell is the core user interface of the GNOME Desktop environment."

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

