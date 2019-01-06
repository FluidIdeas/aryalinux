#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.1.tar.xz

NAME=gsettings-desktop-schemas
VERSION=3.28.1
URL=http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.28/gsettings-desktop-schemas-3.28.1.tar.xz

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

sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in &&

./configure --prefix=/usr &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
