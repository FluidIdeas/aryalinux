#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:accountsservice
#REQ:clutter-gtk
#REQ:colord-gtk
#REQ:gnome-online-accounts
#REQ:gnome-settings-daemon
#REQ:grilo
#REQ:gsound
#REQ:libgtop
#REQ:libpwquality
#REQ:mitkrb
#REQ:shared-mime-info
#REQ:udisks2
#REQ:cheese
#REQ:cups
#REQ:samba
#REQ:gnome-bluetooth
#REQ:ibus
#REQ:libhandy1
#REQ:modemmanager
#REQ:libnma


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gnome-control-center/3.38/gnome-control-center-3.38.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-control-center/3.38/gnome-control-center-3.38.4.tar.xz


NAME=gnome-control-center
VERSION=3.38.4
URL=https://download.gnome.org/sources/gnome-control-center/3.38/gnome-control-center-3.38.4.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Control Center package contains the GNOME settings manager."

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

