#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnome-online-accounts
#REQ:rest
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz


NAME=gfbgraph
VERSION=0.2.3
URL=http://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz

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


./configure --prefix=/usr --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make libgfbgraphdocdir=/usr/share/doc/gfbgraph-0.2.3 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

