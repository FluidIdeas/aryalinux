#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gnome-autoar
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk
#REC:bogofilter
#REC:enchant
#REC:gnome-desktop
#REC:highlight
#REC:libcanberra
#REC:libgweather
#REC:libnotify
#REC:openldap
#REC:seahorse
#OPT:clutter-gtk
#OPT:geoclue2
#OPT:geocode-glib
#OPT:libchamplain
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution/3.28/evolution-3.28.5.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution/3.28/evolution-3.28.5.tar.xz

NAME=evolution
VERSION=3.28.5
URL=http://ftp.gnome.org/pub/gnome/sources/evolution/3.28/evolution-3.28.5.tar.xz

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

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DSYSCONF_INSTALL_DIR=/etc  \
      -DENABLE_INSTALLED_TESTS=ON \
      -DENABLE_LIBCRYPTUI=OFF     \
      -DENABLE_PST_IMPORT=OFF     \
      -DENABLE_GTKSPELL=OFF       \
      -DENABLE_YTNEF=OFF          \
      -DENABLE_CONTACT_MAPS=OFF   \
      -G Ninja .. &&
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
