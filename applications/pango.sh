#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fontconfig
#REQ:freetype2
#REQ:harfbuzz
#REQ:fribidi
#REQ:glib2
#REQ:cairo
#REQ:gobject-introspection
#REQ:x7lib


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/pango/1.48/pango-1.48.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/pango/1.48/pango-1.48.4.tar.xz


NAME=pango
VERSION=1.48.4
URL=https://download.gnome.org/sources/pango/1.48/pango-1.48.4.tar.xz
SECTION="X Libraries"
DESCRIPTION="Pango is a library for laying out and rendering text, with an emphasis on internationalization. It can be used anywhere that text layout is needed, though most of the work on Pango so far has been done in the context of the GTK+ widget toolkit."

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

