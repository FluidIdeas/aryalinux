#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gjs
#REQ:libgweather
#REQ:libhandy1


cd $SOURCE_DIR

NAME=gnome-weather
VERSION=40.0
URL=https://download.gnome.org/sources/gnome-weather/40/gnome-weather-40.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="GNOME Weather is a small application that allows you to monitor the current weather conditions for your city, or anywhere in the world, and to access updated forecasts provided by various internet services."


mkdir -pv $NAME
pushd $NAME

wget -nc https://download.gnome.org/sources/gnome-weather/40/gnome-weather-40.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-weather/40/gnome-weather-40.0.tar.xz


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