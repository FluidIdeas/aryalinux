#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:mtdev
#OPT:valgrind
#OPT:gtk3
#OPT:libwacom

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/libinput/libinput-1.12.5.tar.xz

NAME=libinput
VERSION=1.12.5
URL=https://www.freedesktop.org/software/libinput/libinput-1.12.5.tar.xz

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

export XORG_PREFIX=/usr

mkdir build &&
cd build &&

meson --prefix=$XORG_PREFIX \
-Dudev-dir=/lib/udev \
-Ddebug-gui=false \
-Dtests=false \
-Ddocumentation=false \
-Dlibwacom=false \
.. &&
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
