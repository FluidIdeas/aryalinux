#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libxml2
#REQ:gobject-introspection
#REQ:gtk3
#REQ:libsoup
#REQ:totem-pl-parser
#REQ:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.9.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.9.tar.xz
wget -nc https://gitlab.gnome.org/GNOME/grilo/merge_requests/52.diff


NAME=grilo
VERSION=0.3.9
URL=http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.9.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Grilo is a framework focused on making media discovery and browsing easy for applications and application developers."

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


patch -Np1 -i ../52.diff

mkdir build &&
cd    build    &&

meson --prefix=/usr \
      --libexecdir=/usr/lib \
-Denable-gtk-doc=false .. &&
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

