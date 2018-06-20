#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak x265 package provides a librarybr3ak for encoding video streams into the H.265/HEVC format.br3ak"
SECTION="multimedia"
VERSION=265_2.8
NAME="x265"

#REQ:cmake
#REC:nasm


cd $SOURCE_DIR

URL=https://bitbucket.org/multicoreware/x265/downloads/x265_2.8.tar.gz

if [ ! -z $URL ]
then
wget -nc https://bitbucket.org/multicoreware/x265/downloads/x265_2.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x265/x265_2.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/x265/x265_2.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.8.tar.gz

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

mkdir bld &&
cd    bld &&
cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=/usr ../source &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
rm -vf /usr/lib/libx265.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
