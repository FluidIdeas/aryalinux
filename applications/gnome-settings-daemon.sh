#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Settings Daemon isbr3ak responsible for setting various parameters of a GNOME Session and the applications that runbr3ak under it.br3ak"
SECTION="gnome"
VERSION=3.28.0
NAME="gnome-settings-daemon"

#REQ:colord
#REQ:geoclue2
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
#REQ:x7driver
#REC:cups
#REC:networkmanager
#REC:nss
#REC:wayland


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.28/gnome-settings-daemon-3.28.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
meson --prefix=/usr --sysconfdir=/etc &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sudo udevrulesdir=/lib/udev/rules.d ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
