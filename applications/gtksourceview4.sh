#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:gobject-introspection
#REQ:libxml2


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gtksourceview/4.8/gtksourceview-4.8.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/4.8/gtksourceview-4.8.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/gtksourceview4-4.8.1-buildfix-1.patch


NAME=gtksourceview4
VERSION=4.8.1
URL=https://download.gnome.org/sources/gtksourceview/4.8/gtksourceview-4.8.1.tar.xz
SECTION="X Libraries"
DESCRIPTION="The GtkSourceView package contains libraries used for extending the GTK+ text functions to include syntax highlighting."

mkdir -pv $NAME
pushd $NAME

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


patch -Np1 -i ../gtksourceview4-4.8.1-buildfix-1.patch
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

popd