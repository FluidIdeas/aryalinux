#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The mypaint-brushes packagebr3ak contains brushes used by packages which use libmypaint.br3ak"
SECTION="general"
VERSION=1.3.0
NAME="mypaint-brushes"

#REQ:libmypaint


cd $SOURCE_DIR

URL=https://github.com/Jehan/mypaint-brushes/archive/v1.3.0/mypaint-brushes-v1.3.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/Jehan/mypaint-brushes/archive/v1.3.0/mypaint-brushes-v1.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mypaint-brushes/mypaint-brushes-v1.3.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mypaint-brushes-1.3.0-automake_1.16-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/mypaint-brushes/mypaint-brushes-1.3.0-automake_1.16-1.patch

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

patch -Np1 -i ../mypaint-brushes-1.3.0-automake_1.16-1.patch &&
./autogen.sh                                                 &&
./configure --prefix=/usr                                    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
