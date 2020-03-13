#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gcr
#REQ:gtk3
#REQ:iso-codes
#REQ:libsecret
#REQ:libnotify
#REQ:networkmanager
#REQ:gobject-introspection
#REQ:modemmanager
#REQ:polkit
#REQ:polkit-gnome


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.16/network-manager-applet-1.16.0.tar.xz


NAME=network-manager-applet
VERSION=1.16.0
URL=http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.16/network-manager-applet-1.16.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="The NetworkManager Applet provides a tool and a panel applet used to configure wired and wireless network connections through GUI. It's designed for use with any desktop environment that uses GTK+, such as Xfce and LXDE."

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

meson --prefix=/usr     \
      --sysconfdir=/etc \
      -Dselinux=false   \
      -Dteam=false      \
      -Dmobile_broadband_provider_info=false \
      -Dgtk_doc=false .. &&
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

