#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:gtksourceview4
#REQ:itstool
#REQ:libsoup
#REQ:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.32/gnome-calculator-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.32/gnome-calculator-3.32.2.tar.xz


NAME=gnome-calculator
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.32/gnome-calculator-3.32.2.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="GNOME Calculator is a powerful graphical calculator with financial, logical and scientific modes. It uses a multiple precision package to do its arithmetic to give a high degree of accuracy."

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

