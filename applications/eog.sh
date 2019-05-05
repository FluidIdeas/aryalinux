#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:adwaita-icon-theme
#REQ:exempi
#REQ:gnome-desktop
#REQ:itstool
#REQ:libjpeg
#REQ:libpeas
#REQ:shared-mime-info
#REC:gobject-introspection
#REC:lcms2
#REC:libexif
#REC:librsvg

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/eog/3.32/eog-3.32.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/eog/3.32/eog-3.32.1.tar.xz

NAME=eog
VERSION=3.32.1
URL=http://ftp.gnome.org/pub/gnome/sources/eog/3.32/eog-3.32.1.tar.xz

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

mkdir build &&
cd build &&

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
