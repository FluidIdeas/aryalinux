#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gexiv2
#REQ:gnome-autoar
#REQ:gnome-desktop
#REQ:tracker
#REQ:libnotify
#REC:desktop-file-utils
#REC:exempi
#REC:gobject-introspection
#REC:libexif
#REC:adwaita-icon-theme
#REC:gvfs
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.1.tar.xz

NAME=nautilus
VERSION=3.28.1
URL=http://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.1.tar.xz

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

sed s/\'libm\'/\'m\'/ -i meson.build &&
mkdir build &&
cd    build &&

meson --prefix=/usr      \
      --sysconfdir=/etc  \
      -Dselinux=false    \
      -Dpackagekit=false \
      .. &&

ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install &&
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
