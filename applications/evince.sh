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
#REQ:libsecret
#REQ:nautilus
#REQ:poppler


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.34/evince-3.34.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.34/evince-3.34.2.tar.xz


NAME=evince
VERSION=3.34.2
URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.34/evince-3.34.2.tar.xz
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


CFLAGS="$CFLAGS -I/opt/texlive/2019/include"     \
CXXFLAGS="$CXXFLAGS -I/opt/texlive/2019/include" \
LDFLAGS="$LDFLAGS -L/opt/texlive/2019/lib"
./configure --prefix=/usr                         \
            --enable-introspection                \
            --without-gspell                      \
            --disable-static                     &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
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

