#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libjpeg-turbo is a fork of thebr3ak original IJG libjpeg which usesbr3ak SIMD to accelerate baseline JPEG compression and decompression.br3ak libjpeg is a library thatbr3ak implements JPEG image encoding, decoding and transcoding.br3ak"
SECTION="general"
VERSION=1.5.3
NAME="libjpeg"

#REQ:nasm
#REQ:yasm


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz

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

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-jpeg8            \
            --disable-static        \
            --docdir=/usr/share/doc/libjpeg-turbo-1.5.3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /usr/lib/libjpeg.so*

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
