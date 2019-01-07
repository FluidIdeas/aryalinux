#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk3
#REQ:libcanberra

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz

NAME=gnome-screenshot
VERSION=3.26.0
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -e '/AppData/N;N;p;s/\.appdata\./.metainfo./' \
-i /usr/share/gettext-0.19.8/its/appdata.loc
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
