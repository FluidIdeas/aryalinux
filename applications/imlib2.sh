#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak imlib2 is a graphics library forbr3ak fast file loading, saving, rendering and manipulation.br3ak"
SECTION="x"
VERSION=1.5.1
NAME="imlib2"

#REQ:x7lib
#OPT:libpng
#OPT:libjpeg
#OPT:libtiff
#OPT:giflib


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/enlightenment/imlib2-1.5.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/enlightenment/imlib2-1.5.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/imlib/imlib2-1.5.1.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/imlib2-1.5.1 &&
install -v -m644    doc/{*.gif,index.html} \
                    /usr/share/doc/imlib2-1.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
