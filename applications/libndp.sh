#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libndp package provides abr3ak wrapper for IPv6 Neighbor Discovery Protocol. It also provides abr3ak tool named ndptool for sending and receiving NDP messages.br3ak"
SECTION="basicnet"
VERSION=1.6
NAME="libndp"



cd $SOURCE_DIR

URL=http://libndp.org/files/libndp-1.6.tar.gz

if [ ! -z $URL ]
then
wget -nc http://libndp.org/files/libndp-1.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libndp/libndp-1.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libndp/libndp-1.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libndp/libndp-1.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libndp/libndp-1.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libndp/libndp-1.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libndp/libndp-1.6.tar.gz

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
