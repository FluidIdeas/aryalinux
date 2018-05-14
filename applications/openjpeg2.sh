#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak OpenJPEG is an open-sourcebr3ak implementation of the JPEG-2000 standard. OpenJPEG fully respectsbr3ak the JPEG-2000 specifications and can compress/decompress losslessbr3ak 16-bit images.br3ak"
SECTION="general"
VERSION=2.3.0
NAME="openjpeg2"

#REQ:cmake
#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-2.3.0.tar.gz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
pushd ../doc &&
  for man in man/man?/* ; do
      install -v -D -m 644 $man /usr/share/$man
  done 
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
