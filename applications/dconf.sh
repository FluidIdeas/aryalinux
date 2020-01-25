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

wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.32/dconf-editor-3.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.32/dconf-editor-3.32.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/dconf-0.34.0-meson.patch


NAME=dconf
VERSION=0.32.0
URL=http://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
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


patch -Np1 -i ../dconf-0.34.0-meson.patch
mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc -Dbash_completion=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd ..              &&
tar -xf ../dconf-editor-3.32.0.tar.xz &&
cd dconf-editor-3.32.0                &&

mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc .. &&
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

