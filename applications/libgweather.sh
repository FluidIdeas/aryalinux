#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:geocode-glib
#REQ:gtk3
#REQ:libsoup
#REQ:gobject-introspection
#REQ:libxml2
#REQ:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgweather/3.34/libgweather-3.34.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgweather/3.34/libgweather-3.34.0.tar.xz


NAME=libgweather
VERSION=3.34.0
URL=http://ftp.gnome.org/pub/gnome/sources/libgweather/3.34/libgweather-3.34.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The libgweather package is a library used to access weather information from online services for numerous locations."

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


sed -i '338a "KX26",' libgweather/test_libgweather.c
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

