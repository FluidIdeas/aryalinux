#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This package, from the WebM project, provides the referencebr3ak implementations of the VP8 Codec, used in most current html5 video,br3ak and of the next-generation VP9 Codec.br3ak"
SECTION="multimedia"
VERSION=1.7.0
NAME="libvpx"

#REQ:yasm
#REQ:nasm
#REQ:general_which
#OPT:doxygen
#OPT:php


cd $SOURCE_DIR

URL=https://github.com/webmproject/libvpx/archive/v1.7.0/libvpx-1.7.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/webmproject/libvpx/archive/v1.7.0/libvpx-1.7.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libvpx/libvpx-1.7.0.tar.gz

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

sed -i 's/cp -p/cp/' build/make/Makefile &&
mkdir libvpx-build            &&
cd    libvpx-build            &&
../configure --prefix=/usr    \
             --enable-shared  \
             --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
