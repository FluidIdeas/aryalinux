#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Little Color Management System is a small-footprint colorbr3ak management engine, with special focus on accuracy and performance.br3ak It uses the International Color Consortium standard (ICC), which isbr3ak the modern standard for color management.br3ak"
SECTION="general"
VERSION=2.9
NAME="lcms2"

#OPT:libjpeg
#OPT:libtiff


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lcms/lcms2-2.9.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lcms/lcms2-2.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.9.tar.gz

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

sed -i '/AX_APPEND/s/^/#/' configure.ac &&
autoreconf


./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
