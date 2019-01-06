#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:colord
#REQ:fontconfig
#REQ:geoclue2
#REQ:gnome-desktop
#REQ:libcanberra
#REQ:libnotify
#REQ:librsvg
#REQ:libwacom
#REQ:pulseaudio
#REQ:systemd
#REQ:upower
#REQ:xorg-wacom-driver
#REC:alsa
#REC:cups
#REC:networkmanager
#REC:wayland

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.1.tar.xz

NAME=gnome-settings-daemon
VERSION=3.28.1
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.1.tar.xz

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

meson --prefix=/usr --sysconfdir=/etc .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
