#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gnome-autoar
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk
#REQ:bogofilter
#REQ:enchant
#REQ:gnome-desktop
#REQ:highlight
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:openldap
#REQ:seahorse


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution/3.32/evolution-3.32.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution/3.32/evolution-3.32.4.tar.xz


NAME=evolution
VERSION=3.32.4
URL=http://ftp.gnome.org/pub/gnome/sources/evolution/3.32/evolution-3.32.4.tar.xz

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

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DSYSCONF_INSTALL_DIR=/etc  \
      -DENABLE_INSTALLED_TESTS=ON \
      -DENABLE_PST_IMPORT=OFF     \
      -DENABLE_GTKSPELL=OFF       \
      -DENABLE_YTNEF=OFF          \
      -DENABLE_CONTACT_MAPS=OFF   \
      -G Ninja .. &&
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

