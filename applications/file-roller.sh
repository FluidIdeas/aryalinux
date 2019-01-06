#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk3
#REQ:itstool
#REC:cpio
#REC:desktop-file-utils
#REC:json-glib
#REC:libarchive
#REC:libnotify
#REC:nautilus
#OPT:unrar
#OPT:unzip
#OPT:zip

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.28/file-roller-3.28.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.28/file-roller-3.28.1.tar.xz

NAME=file-roller
VERSION=3.28.1
URL=http://ftp.gnome.org/pub/gnome/sources/file-roller/3.28/file-roller-3.28.1.tar.xz

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
cd    build &&

meson --prefix=/usr -Dpackagekit=false .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install &&
chmod -v 0755 /usr/libexec/file-roller/isoinfo.sh &&
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
