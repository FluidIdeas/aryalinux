#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk4
#REQ:pcre2
#REQ:gobject-introspection
#REQ:libxml2


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gtksourceview/5.0/gtksourceview-5.0.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/5.0/gtksourceview-5.0.0.tar.xz


NAME=gtksourceview5
VERSION=5.0.0
URL=https://download.gnome.org/sources/gtksourceview/5.0/gtksourceview-5.0.0.tar.xz
SECTION="X Libraries"
DESCRIPTION="The GtkSourceView package contains a library used for extending the GTK text functions to include syntax highlighting."

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

meson --prefix=/usr .. &&
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
