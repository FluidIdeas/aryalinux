#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:util-macros


cd $SOURCE_DIR

wget -nc https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2


NAME=xorgproto
VERSION=2018.4
URL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2

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

XORG_PREFIX="/usr"

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2018.4 &&
install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2018.4
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

