#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libcddb is a library thatbr3ak implements the different protocols (CDDBP, HTTP, SMTP) to accessbr3ak data on a CDDB server.br3ak"
SECTION="multimedia"
VERSION=1.3.2
NAME="libcddb"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
