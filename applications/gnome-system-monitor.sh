#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:adwaita-icon-theme
#REQ:gtkmm3
#REQ:itstool
#REQ:libgtop
#REQ:librsvg


cd $SOURCE_DIR

NAME=gnome-system-monitor
VERSION=42.0
URL=https://download.gnome.org/sources/gnome-system-monitor/42/gnome-system-monitor-42.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="The GNOME System Monitor package contains GNOME's replacement for gtop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-system-monitor/42/gnome-system-monitor-42.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-system-monitor/42/gnome-system-monitor-42.0.tar.xz


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

meson setup --prefix=/usr --buildtype=release .. &&
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