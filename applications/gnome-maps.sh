#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:clutter-gtk
#REQ:folks
#REQ:geocode-glib
#REQ:gjs
#REQ:libchamplain

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.28/gnome-maps-3.28.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.28/gnome-maps-3.28.2.tar.xz

NAME=gnome-maps
VERSION=3.28.2
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.28/gnome-maps-3.28.2.tar.xz

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

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
