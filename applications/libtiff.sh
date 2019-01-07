#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:cmake
#OPT:freeglut
#OPT:libjpeg
#OPT:libwebp

cd $SOURCE_DIR

wget -nc http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz

NAME=libtiff
VERSION=4.0.10
URL=http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz

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

mkdir -p libtiff-build &&
cd libtiff-build &&

cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.0.10 \
-DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
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
