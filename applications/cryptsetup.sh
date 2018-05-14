#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak cryptsetup is used to set up transparent encryption of blockbr3ak devices using the kernel crypto API.br3ak"
SECTION="postlfs"
VERSION=2.0.2
NAME="cryptsetup"

#REQ:json-c
#REQ:lvm2
#REQ:popt
#OPT:libgcrypt
#OPT:nettle
#OPT:nss
#OPT:libpwquality
#OPT:python2


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/cryptsetup-2.0.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/cryptsetup-2.0.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cryptsetup/cryptsetup-2.0.2.tar.xz

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

./configure --prefix=/usr \
            --with-crypto_backend=openssl &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
