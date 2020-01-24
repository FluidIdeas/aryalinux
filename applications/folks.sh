#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:evolution-data-server
#REQ:gobject-introspection
#REQ:libgee
#REQ:python2
#REQ:telepathy-glib
#REQ:bluez
#REQ:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/folks/0.12/folks-0.12.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/folks/0.12/folks-0.12.1.tar.xz


NAME=folks
VERSION=0.12.1
URL=http://ftp.gnome.org/pub/gnome/sources/folks/0.12/folks-0.12.1.tar.xz
SECTION="Gnome"
DESCRIPTION="Folks is a library that aggregates people from multiple sources (e.g, Telepathy connection managers and eventually Evolution Data Server, Facebook, etc.) to create metacontacts."

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
cd build &&

meson --prefix=/usr --sysconfdir=/etc .. &&
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

