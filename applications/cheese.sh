#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clutter-gst
#REQ:clutter-gtk
#REQ:gnome-desktop
#REQ:gnome-video-effects
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-good
#REQ:v4l-utils
#REQ:itstool
#REQ:libcanberra
#REQ:libgudev
#REC:gobject-introspection
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cheese/3.32/cheese-3.32.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cheese/3.32/cheese-3.32.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/cheese-3.32.1-gst_debug_disabled-1.patch

NAME=cheese
VERSION=3.32.1
URL=http://ftp.gnome.org/pub/gnome/sources/cheese/3.32/cheese-3.32.1.tar.xz

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

patch -Np1 -i ../cheese-3.32.1-gst_debug_disabled-1.patch &&

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
