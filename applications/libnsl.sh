#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libnsl package contains thebr3ak public client interface for NIS(YP) and NIS+. It replaces the NISbr3ak library that used to be in glibc.br3ak"
SECTION="basicnet"
VERSION=1.2.0
NAME="libnsl"

#REQ:rpcsvc-proto
#REQ:libtirpc


cd $SOURCE_DIR

URL=https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnsl/libnsl-1.2.0.tar.gz

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
make install                  &&
mv /usr/lib/libnsl.so.2* /lib &&
ln -sfv ../../lib/libnsl.so.2.0.0 /usr/lib/libnsl.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
