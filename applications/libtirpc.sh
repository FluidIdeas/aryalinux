#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libtirpc package containsbr3ak libraries that support programs that use the Remote Procedure Callbr3ak (RPC) API. It replaces the RPC, but not the NIS library entriesbr3ak that used to be in glibc.br3ak"
SECTION="basicnet"
VERSION=1.1.4
NAME="libtirpc"

#OPT:mitkrb


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libtirpc/libtirpc-1.1.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.1.4.tar.bz2

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

./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --disable-static                                \
            --disable-gssapi                                &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
