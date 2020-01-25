#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libseccomp
#REQ:libxml2
#REQ:xkeyboard-config
#REQ:bubblewrap
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.32/gnome-desktop-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.32/gnome-desktop-3.32.2.tar.xz


NAME=gnome-desktop
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.32/gnome-desktop-3.32.2.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Desktop package contains a library that provides an API shared by several applications on the GNOME Desktop."

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
cd build &&

meson --prefix=/usr                 \
      -Dgnome_distributor="BLFS" .. &&
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

