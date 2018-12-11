#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Freeglut is intended to be a 100%br3ak compatible, completely opensourced clone of the GLUT library. GLUTbr3ak is a window system independent toolkit for writing OpenGL programs,br3ak implementing a simple windowing API, which makes learning about andbr3ak exploring OpenGL programming very easy.br3ak"
SECTION="x"
VERSION=3.0.0
NAME="freeglut"

#REQ:cmake
#REQ:mesa
#REC:glu


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

mkdir build &&
cd    build &&
CMAKE_LIBRARY_PATH=/usr/lib     \
CMAKE_INCLUDE_PATH=/usr/include \
cmake -DCMAKE_INSTALL_PREFIX=/usr       \
      -DCMAKE_BUILD_TYPE=Release        \
      -DFREEGLUT_BUILD_DEMOS=OFF        \
      -DFREEGLUT_BUILD_STATIC_LIBS=OFF  \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
