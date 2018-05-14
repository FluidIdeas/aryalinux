#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Potrace™ is a tool forbr3ak transforming a bitmap (PBM, PGM, PPM, or BMP format) into one ofbr3ak several vector file formats.br3ak"
SECTION="general"
VERSION=1.15
NAME="potrace"

#REC:llvm


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/potrace/potrace-1.15.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/potrace/potrace-1.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/potrace/potrace-1.15.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/potrace/potrace-1.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/potrace/potrace-1.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/potrace/potrace-1.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/potrace/potrace-1.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/potrace/potrace-1.15.tar.gz

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

./configure --prefix=/usr                        \
            --disable-static                     \
            --docdir=/usr/share/doc/potrace-1.15 \
            --enable-a4                          \
            --enable-metric                      \
            --with-libpotrace                    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
