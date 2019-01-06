#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib-networking
#REQ:libpsl
#REQ:libxml2
#REQ:sqlite
#REC:gobject-introspection
#REC:vala
#OPT:apache
#OPT:curl
#OPT:mitkrb
#OPT:gtk-doc
#OPT:php
#OPT:samba

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libsoup/2.64/libsoup-2.64.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsoup/2.64/libsoup-2.64.2.tar.xz

NAME=libsoup
VERSION=2.64.2
URL=http://ftp.gnome.org/pub/gnome/sources/libsoup/2.64/libsoup-2.64.2.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr -Dvapi=true -Dgssapi=false .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
