#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The rpcsvc-proto package containsbr3ak the rcpsvc protocol.x files and headers, formerly included withbr3ak GlibC, that are not included in replacement <a class=\"xref\" href=\"libtirpc.html\" title=\"libtirpc-1.0.3\">libtirpc-1.0.3</a>, alongbr3ak with the rpcgen program.br3ak"
SECTION="basicnet"
VERSION=1.3.1
NAME="rpcsvc-proto"



cd $SOURCE_DIR

URL=https://github.com/thkukuk/rpcsvc-proto/archive/v1.3.1/rpcsvc-proto-1.3.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/thkukuk/rpcsvc-proto/archive/v1.3.1/rpcsvc-proto-1.3.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rpcsvc-proto/rpcsvc-proto-1.3.1.tar.gz

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

autoreconf -fi                &&
./configure --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
