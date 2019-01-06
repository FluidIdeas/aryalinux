#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus
#REQ:glib2
#REQ:gtk3
#REQ:libxml2
#REC:libxslt
#REC:vala
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf/0.30/dconf-0.30.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf/0.30/dconf-0.30.1.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.30/dconf-editor-3.30.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.30/dconf-editor-3.30.2.tar.xz

NAME=dconf
VERSION=0.30.1
URL=http://ftp.gnome.org/pub/gnome/sources/dconf/0.30/dconf-0.30.1.tar.xz

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

meson --prefix=/usr --sysconfdir=/etc .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install &&
cp gsettings/libdconfsettings.so /usr/lib/gio/modules/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cd ..              &&
tar -xf ../dconf-editor-3.30.2.tar.xz &&
cd dconf-editor-3.30.2                &&

mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc -Dbash_completion=false .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
