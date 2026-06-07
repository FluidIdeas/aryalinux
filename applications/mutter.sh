#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:at-spi2-core
#REQ:python-modules#docutils
#REQ:graphene
#REQ:libei
#REQ:libxcvt
#REQ:pipewire
#REQ:desktop-file-utils
#REQ:glib2
#REQ:libdisplay-info
#REQ:startup-notification
#REQ:x7driver
#REQ:xwayland

cd $SOURCE_DIR
NAME=mutter
VERSION=49.4
URL=https://download.gnome.org/sources/mutter/49/mutter-49.4.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/mutter/49/mutter-49.4.tar.xz


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

sed "/tests_c_args =/s/$/ + ['-U', 'G_DISABLE_ASSERT']/" -i src/tests/meson.build
sed "/c_args:/a '-U', 'G_DISABLE_ASSERT'," -i src/tests/cogl/unit/meson.build
mkdir build
cd    build
meson setup --prefix=/usr            \
            --buildtype=release      \
            -D tests=disabled        \
            -D profiler=false        \
            -D bash_completion=false \
            ..
ninja
mutter --wayland -- vte-2.91
MUTTER_DEBUG_DUMMY_MODE_SPECS=1920x1080 mutter --wayland --nested -- vte-2.91


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