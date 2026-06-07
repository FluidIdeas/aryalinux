#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:libhandy1
#REQ:gnome-keyring
#REQ:poppler

cd $SOURCE_DIR
NAME=evince
VERSION=48.1
URL=https://download.gnome.org/sources/evince/48/evince-48.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/evince/48/evince-48.1.tar.xz


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

mkdir build
cd    build
CPPFLAGS+=" -I/opt/texlive/2025/include -DNO_DEBUG" \
meson setup --prefix=/usr                \
            --buildtype=release          \
            -D gtk_doc=false             \
            --wrap-mode=nodownload       \
            ..
ninja
sed "/docs_dir/s@\$@ / 'evince-48.1'@" -i ../help/meson.build
meson configure -D gtk_doc=true
ninja
glib-compile-schemas /usr/share/glib-2.0/schemas


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