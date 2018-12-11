#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The JasPer Project is anbr3ak open-source initiative to provide a free software-based referencebr3ak implementation of the JPEG-2000 codec.br3ak"
SECTION="general"
VERSION=2.0.14
NAME="jasper"

#REQ:cmake
#REC:libjpeg
#OPT:freeglut
#OPT:doxygen
#OPT:texlive


cd $SOURCE_DIR

URL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-2.0.14.tar.gz

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

mkdir BUILD &&
cd    BUILD &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DCMAKE_SKIP_INSTALL_RPATH=YES \
      -DJAS_ENABLE_DOC=NO            \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/jasper-2.0.14 \
      ..  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
