#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:colord
#REQ:fontconfig
#REQ:geoclue2
#REQ:geocode-glib
#REQ:gnome-desktop
#REQ:lcms2
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:librsvg
#REQ:libwacom
#REQ:pulseaudio
#REQ:systemd
#REQ:upower
#REQ:xorg-wacom-driver
#REQ:alsa
#REQ:cups
#REQ:networkmanager
#REQ:nss
#REQ:wayland


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.34/gnome-settings-daemon-3.34.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.34/gnome-settings-daemon-3.34.2.tar.xz


NAME=gnome-settings-daemon
VERSION=3.34.2
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.34/gnome-settings-daemon-3.34.2.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Settings Daemon is responsible for setting various parameters of a GNOME Session and the applications that run under it."

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

meson --prefix=/usr --sysconfdir=/etc .. &&
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

