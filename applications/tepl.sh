#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:amtk
#REQ:gtksourceview4
#REQ:icu
#REQ:uchardet


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/tepl/5.0/tepl-5.0.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/tepl/5.0/tepl-5.0.1.tar.xz


NAME=tepl
VERSION=5.0.1
URL=https://download.gnome.org/sources/tepl/5.0/tepl-5.0.1.tar.xz
SECTION="X Libraries"
DESCRIPTION="The Tepl package contains a library that eases the development of GtkSourceView-based text editors and IDEs."

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
