#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:desktop-file-utils
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:libarchive
#REQ:glib2
#REQ:vala

cd $SOURCE_DIR
NAME=gucharmap
VERSION=17.0.1
URL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.1/gucharmap-17.0.1.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.1/gucharmap-17.0.1.tar.bz2


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
mkdir ucd
pushd ucd
unzip ../../../UCD.zip
cp -v ../../../Unihan.zip .
popd
meson setup --prefix=/usr       \
            --strip             \
            --buildtype=release \
            -D ucd_path=./ucd   \
            -D docs=false       \
            ..
ninja
rm  -fv /usr/share/glib-2.0/schemas/org.gnome.Charmap.enums.xml


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