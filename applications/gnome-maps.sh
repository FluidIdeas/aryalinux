#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:clutter-gtk
#REQ:desktop-file-utils
#REQ:folks
#REQ:geoclue2
#REQ:geocode-glib
#REQ:gfbgraph
#REQ:gjs
#REQ:libchamplain
#REQ:libgee
#REQ:libhandy1
#REQ:rest


cd $SOURCE_DIR

NAME=gnome-maps
VERSION=40.0
URL=https://download.gnome.org/sources/gnome-maps/40/gnome-maps-40.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="GNOME Maps is a map application for GNOME."


mkdir -pv $NAME
pushd $NAME

wget -nc https://download.gnome.org/sources/gnome-maps/40/gnome-maps-40.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-maps/40/gnome-maps-40.0.tar.xz


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

popd