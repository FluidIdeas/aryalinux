#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libsoup
#REQ:gobject-introspection
#REQ:libarchive
#REQ:libgcrypt


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.3.tar.xz


NAME=totem-pl-parser
VERSION=3.26.3
URL=http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.3.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Totem PL Parser package contains a simple GObject-based library used to parse multiple playlist formats."

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

meson --prefix /usr --default-library shared .. &&
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

