#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The NetworkManager Applet providesbr3ak a tool and a panel applet used to configure wired and wirelessbr3ak network connections through GUI. It's designed for use with anybr3ak desktop environment that uses GTK+br3ak like Xfce and LXDE.br3ak"
SECTION="gnome"
VERSION=1.8.10
NAME="network-manager-applet"

#REQ:gtk3
#REQ:iso-codes
#REQ:libsecret
#REQ:libnotify
#REQ:networkmanager
#REQ:polkit-gnome
#REQ:ModemManager
#REC:gobject-introspection
#REC:ModemManager
#OPT:gc
#OPT:gnome-bluetooth


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.10.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.10.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.8.10.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.10.tar.xz

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
meson --prefix=/usr     \
      --sysconfdir=/etc \
      -Dselinux=false   \
      -Dteam=false      &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
