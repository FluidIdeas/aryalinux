#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk3
#REQ:iso-codes
#REQ:libsecret
#REQ:libnotify
#REQ:networkmanager
#REQ:polkit-gnome
#REC:gobject-introspection
#REC:ModemManager
#OPT:gc
#OPT:gnome-bluetooth
#OPT:jansson

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.16.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.16.tar.xz

NAME=network-manager-applet
VERSION=1.8.16
URL=http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.16.tar.xz

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
cd    build &&

meson --prefix=/usr     \
      --sysconfdir=/etc \
      -Dselinux=false   \
      -Dteam=false      \
      -Dmobile_broadband_provider_info=false .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
