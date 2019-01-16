#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk3
#REC:gobject-introspection
#OPT:vala
#OPT:valgrind
#OPT:gtk-doc
#OPT:itstool
#OPT:fop

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.24/gtksourceview-3.24.9.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.24/gtksourceview-3.24.9.tar.xz

NAME=gtksourceview
VERSION=3.24.9
URL=http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.24/gtksourceview-3.24.9.tar.xz

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

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
