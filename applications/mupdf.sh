#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak MuPDF is a lightweight PDF and XPSbr3ak viewer.br3ak"
SECTION="pst"
VERSION=1.14.0
NAME="mupdf"

#REQ:x7lib
#REQ:xorg-server
#REC:freeglut
#REC:harfbuzz
#REC:lcms2
#REC:libjpeg
#REC:openjpeg2
#REC:curl
#OPT:xdg-utils


cd $SOURCE_DIR

URL=http://www.mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.14.0-source.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mupdf-1.14.0-shared_libs-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/mupdf/mupdf-1.14.0-shared_libs-1.patch

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

patch -Np1 -i ../mupdf-1.14.0-shared_libs-1.patch &&
USE_SYSTEM_LIBS=yes make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr                      \
     build=release                    \
     docdir=/usr/share/doc/mupdf-1.14.0 \
     install                          &&
ln -sfv mupdf-x11 /usr/bin/mupdf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
