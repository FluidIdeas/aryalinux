#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libgee
#REQ:gtk3
#REQ:glib2
#REQ:glib-networking


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/GNOME/sources/libgnome-games-support/1.6/libgnome-games-support-1.6.0.1.tar.xz
wget -nc ftp.gnome.org/pub/GNOME/sources/libgnome-games-support/1.6/libgnome-games-support-1.6.0.1.tar.xz


NAME=libgnome-games-support
VERSION=1.6.0.1
URL=ftp.gnome.org/pub/GNOME/sources/libgnome-games-support/1.6/libgnome-games-support-1.6.0.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="libgnome-games-support is a small library intended for internal use by the games developed by the GNOME project."

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

meson --prefix=/usr      \
      --sysconfdir=/etc  \
      .. &&

ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

