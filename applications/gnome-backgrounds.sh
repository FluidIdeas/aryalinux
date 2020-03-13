#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-backgrounds/3.36/gnome-backgrounds-3.36.0.tar.xz
wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-backgrounds/3.36/gnome-backgrounds-3.36.0.tar.xz


NAME=gnome-backgrounds
VERSION=3.36.0
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-backgrounds/3.36/gnome-backgrounds-3.36.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Backgrounds package contains a collection of graphics files which can be used as backgrounds in the GNOME Desktop environment. Additionally, the package creates the proper framework and directory structure so that you can add your own files to the collection."

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

