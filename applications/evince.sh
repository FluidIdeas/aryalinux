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
#REQ:libhandy1
#REQ:libxml2
#REQ:openjpeg2
#REQ:gnome-keyring
#REQ:gobject-introspection
#REQ:libarchive
#REQ:libsecret
#REQ:nautilus
#REQ:poppler


cd $SOURCE_DIR

NAME=evince
VERSION=43.1
URL=https://download.gnome.org/sources/evince/43/evince-43.1.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Evince is a document viewer for multiple document formats. It supports PDF, Postscript, DjVu, TIFF and DVI. It is useful for viewing documents of various types using one simple application instead of the multiple document viewers that once existed on the GNOME Desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/evince/43/evince-43.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/evince/43/evince-43.1.tar.xz


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


export CPPFLAGS="-I/opt/texlive/2023/include" &&
export LDFLAGS="$LDFLAGS -L/opt/texlive/2023/lib"
mkdir build &&
cd    build &&

meson setup --prefix=/usr          \
            --buildtype=release    \
            -Dgtk_doc=false        \
            --wrap-mode=nodownload \
            ..                     &&
ninja
sed "/fatal-warnings/d" -i ../help/reference/*/meson.build    &&
sed "/docs_dir/s@\$@ / 'evince-43.1'@" -i ../help/meson.build &&
meson configure -Dgtk_doc=true                                &&
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

popd