#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:glib2
#REQ:gtk3
#REQ:libxml2
#REQ:libxslt
#REQ:vala


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/dconf/0.38/dconf-0.38.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/dconf/0.38/dconf-0.38.0.tar.xz
wget -nc https://download.gnome.org/sources/dconf-editor/3.38/dconf-editor-3.38.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/dconf-editor/3.38/dconf-editor-3.38.2.tar.xz


NAME=dconf
VERSION=0.38.0
URL=https://download.gnome.org/sources/dconf/0.38/dconf-0.38.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The DConf package contains a low-level configuration system. Its main purpose is to provide a backend to GSettings on platforms that don't already have configuration storage systems."

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

meson --prefix=/usr -Dbash_completion=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd ..              &&
tar -xf ../dconf-editor-3.38.2.tar.xz &&
cd dconf-editor-3.38.2                &&

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

