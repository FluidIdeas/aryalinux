#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak LZO is a data compression librarybr3ak which is suitable for data decompression and compression inbr3ak real-time. This means it favors speed over compression ratio.br3ak"
SECTION="general"
VERSION=2.10
NAME="lzo"



cd $SOURCE_DIR

URL=http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lzo/lzo-2.10.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lzo/lzo-2.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lzo/lzo-2.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lzo/lzo-2.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lzo/lzo-2.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lzo/lzo-2.10.tar.gz

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

./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.10 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
