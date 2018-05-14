#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak AAlib is a library to render anybr3ak graphic into ASCII Art.br3ak"
SECTION="general"
VERSION=5
NAME="aalib"

#OPT:slang
#OPT:gpm
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz

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

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4


./configure --prefix=/usr             \
            --infodir=/usr/share/info \
            --mandir=/usr/share/man   \
            --disable-static          &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
