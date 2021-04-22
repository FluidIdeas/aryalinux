#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtkmm/3.24/gtkmm-3.24.4.tar.xz


NAME=gtkmm3
VERSION=3.24.4
URL=https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.4.tar.xz
SECTION="X Libraries"
DESCRIPTION="The Gtkmm package provides a C++ interface to GTK+ 3."

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


mkdir gtkmm3-build &&
cd    gtkmm3-build &&

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

