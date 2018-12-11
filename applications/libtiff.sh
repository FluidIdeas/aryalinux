#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LibTIFF package contains thebr3ak TIFF libraries and associated utilities. The libraries are used bybr3ak many programs for reading and writing TIFF files and the utilitiesbr3ak are used for general work with TIFF files.br3ak"
SECTION="general"
VERSION=4.0.9
NAME="libtiff"

#REC:cmake
#OPT:freeglut
#OPT:libjpeg


cd $SOURCE_DIR

URL=http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz

if [ ! -z $URL ]
then
wget -nc http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.9.tar.gz

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

mkdir -p libtiff-build &&
cd       libtiff-build &&
cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.0.9 \
      -DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
