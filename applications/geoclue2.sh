#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:json-glib
#REQ:libnotify
#REQ:vala

cd $SOURCE_DIR
NAME=geoclue2
VERSION=2.8.0
URL=https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.8.0/geoclue-2.8.0.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.8.0/geoclue-2.8.0.tar.bz2


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

mkdir build
cd    build
meson setup --prefix=/usr        \
            --buildtype=release  \
            -D gtk-doc=false     \
            -D nmea-source=false \
            ..
ninja
cat > /etc/geoclue/conf.d/90-lfs-google.conf << "EOF"
# Begin /etc/geoclue/conf.d/90-lfs-google.conf

# This configuration applies for the WiFi source.
[wifi]

# Set the URL to Google's Geolocation Service.
url=https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ

# End /etc/geoclue/conf.d/90-lfs-google.conf
EOF


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