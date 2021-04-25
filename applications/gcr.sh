#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libgcrypt
#REQ:p11-kit
#REQ:gnupg
#REQ:gobject-introspection
#REQ:gtk3
#REQ:libxslt
#REQ:vala


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gcr/3.38/gcr-3.38.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gcr/3.38/gcr-3.38.1.tar.xz


NAME=gcr
VERSION=3.38.1
URL=https://download.gnome.org/sources/gcr/3.38/gcr-3.38.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Gcr package contains libraries used for displaying certificates and accessing key stores. It also provides the viewer for crypto files on the GNOME Desktop."

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


sed -i 's:"/desktop:"/org:' schema/*.xml &&

mkdir gcr-build &&
cd    gcr-build &&

meson --prefix=/usr -Dgtk_doc=false .. &&
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

