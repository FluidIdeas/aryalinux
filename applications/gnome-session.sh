#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:systemd
#REQ:upower


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gnome-session/3.38/gnome-session-3.38.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-session/3.38/gnome-session-3.38.0.tar.xz


NAME=gnome-session
VERSION=3.38.0
URL=https://download.gnome.org/sources/gnome-session/3.38/gnome-session-3.38.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Session package contains the GNOME session manager."

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


sed 's@/bin/sh@/bin/sh -l@' -i gnome-session/gnome-session.in
echo 'Slice=-.slice' >> data/gnome-session-restart-dbus.service.in
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

