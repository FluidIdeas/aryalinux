#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libiodbc is an API to ODBCbr3ak compatible databases.br3ak"
SECTION="general"
VERSION=3.52.12
NAME="libiodbc"

#REC:gtk2


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/iodbc/libiodbc-3.52.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/iodbc/libiodbc-3.52.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libiodbc/libiodbc-3.52.12.tar.gz

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

./configure --prefix=/usr                   \
            --with-iodbc-inidir=/etc/iodbc  \
            --includedir=/usr/include/iodbc \
            --disable-libodbc               \
            --disable-static                &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
