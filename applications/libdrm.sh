#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:x7lib
#OPT:cairo
#OPT:docbook
#OPT:docbook-xsl
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://dri.freedesktop.org/libdrm/libdrm-2.4.96.tar.bz2

NAME=libdrm
VERSION=2.4.96.
URL=https://dri.freedesktop.org/libdrm/libdrm-2.4.96.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir build &&
cd build &&

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
