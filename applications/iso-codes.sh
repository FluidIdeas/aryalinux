#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ISO Codes package contains abr3ak list of country, language and currency names and it is used as abr3ak central database for accessing this data.br3ak"
SECTION="general"
VERSION=4.1
NAME="iso-codes"



cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/iso-codes/iso-codes-4.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/iso-codes/iso-codes-4.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/iso-codes/iso-codes-4.1.tar.xz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make


sed -i '/^LN_S/s/s/sfvn/' */Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
