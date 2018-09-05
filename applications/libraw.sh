#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Libraw is a library for readingbr3ak RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF,br3ak DNG, and others).br3ak"
SECTION="general"
VERSION=0.18.11
NAME="libraw"

#REC:libjpeg
#REC:jasper
#REC:lcms2


cd $SOURCE_DIR

URL=http://www.libraw.org/data/LibRaw-0.18.11.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.libraw.org/data/LibRaw-0.18.11.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.18.11.tar.gz

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

./configure --prefix=/usr    \
            --enable-jpeg    \
            --enable-jasper  \
            --enable-lcms    \
            --disable-static \
            --docdir=/usr/share/doc/libraw-0.18.11 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
