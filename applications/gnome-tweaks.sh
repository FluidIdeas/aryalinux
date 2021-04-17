#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:libhandy1
#REQ:python-modules#pygobject3
#REQ:sound-theme-freedesktop


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gnome-tweaks/3.34/gnome-tweaks-3.34.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-tweaks/3.34/gnome-tweaks-3.34.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/fetch-kde-framework/gnome-tweaks-3.34.1-port_to_libhandy1-1.patch


NAME=gnome-tweaks
VERSION=3.34.1
URL=https://download.gnome.org/sources/gnome-tweaks/3.34/gnome-tweaks-3.34.1.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="GNOME Tweaks is a simple program used to tweak advanced GNOME settings."

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


patch -Np1 -i ../gnome-tweaks-3.34.1-port_to_libhandy1-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr &&
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

