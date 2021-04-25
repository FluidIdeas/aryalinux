#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REQ:openjpeg2
#REQ:gnome-keyring
#REQ:gobject-introspection
#REQ:libarchive
#REQ:libsecret
#REQ:nautilus
#REQ:poppler


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/evince/3.38/evince-3.38.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/evince/3.38/evince-3.38.2.tar.xz


NAME=evince
VERSION=3.38.2
URL=https://download.gnome.org/sources/evince/3.38/evince-3.38.2.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Evince is a document viewer for multiple document formats. It supports PDF, Postscript, DjVu, TIFF and DVI. It is useful for viewing documents of various types using one simple application instead of the multiple document viewers that once existed on the GNOME Desktop."

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


export CFLAGS="$CFLAGS -I/opt/texlive/2020/include" &&
export CXXFLAGS="$CXXFLAGS -I/opt/texlive/2020/include" &&
export LDFLAGS="$LDFLAGS -L/opt/texlive/2020/lib"
mkdir build &&
cd    build &&

meson --prefix=/usr -Dgtk_doc=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

