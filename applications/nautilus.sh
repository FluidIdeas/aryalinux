#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:gexiv2
#REQ:desktop-file-utils
#REQ:glib2
#REQ:gst10-plugins-base
#REQ:libcloudproviders
#REQ:localsearch
#REQ:adwaita-icon-theme
#REQ:gvfs

cd $SOURCE_DIR
NAME=nautilus
VERSION=49.3
URL=https://download.gnome.org/sources/nautilus/49/nautilus-49.3.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/nautilus/49/nautilus-49.3.tar.xz


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

rm -fv /usr/lib/libnautilus-extension.so.4
mkdir build
cd    build
meson setup --prefix=/usr       \
            --buildtype=release \
            ..
ninja
sed "/docdir =/s@\$@ / 'nautilus-49.3'@" -i ../meson.build
meson configure -D docs=true
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