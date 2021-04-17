#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:clutter
#REQ:clutter-gtk
#REQ:gtk3
#REQ:libsoup
#REQ:sqlite
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/libchamplain/0.12/libchamplain-0.12.20.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.20.tar.xz


NAME=libchamplain
VERSION=0.12.20
URL=https://download.gnome.org/sources/libchamplain/0.12/libchamplain-0.12.20.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The libchamplain package contains a Clutter-based widget that is used to display rich and interactive maps."

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

