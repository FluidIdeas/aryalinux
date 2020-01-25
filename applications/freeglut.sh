#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake
#REQ:mesa
#REQ:glu


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz


NAME=freeglut
VERSION=3.0.0
URL=https://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz
SECTION="X Libraries"
DESCRIPTION="Freeglut is intended to be a 100% compatible, completely opensourced clone of the GLUT library. GLUT is a window system independent toolkit for writing OpenGL programs, implementing a simple windowing API, which makes learning about and exploring OpenGL programming very easy."

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

export XORG_PREFIX="/usr"

mkdir build &&
cd    build &&

CMAKE_LIBRARY_PATH=$XORG_PREFIX/lib     \
CMAKE_INCLUDE_PATH=$XORG_PREFIX/include \
cmake -DCMAKE_INSTALL_PREFIX=/usr       \
      -DCMAKE_BUILD_TYPE=Release        \
      -DFREEGLUT_BUILD_DEMOS=OFF        \
      -DFREEGLUT_BUILD_STATIC_LIBS=OFF  \
      .. &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

