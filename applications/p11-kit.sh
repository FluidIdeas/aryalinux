#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The p11-kit package provides a waybr3ak to load and enumerate PKCS #11 (a Cryptographic Token Interfacebr3ak Standard) modules.br3ak"
SECTION="postlfs"
VERSION=0.23.14
NAME="p11-kit"

#REQ:nss
#REC:libtasn1
#OPT:make-ca
#OPT:nss
#OPT:gtk-doc
#OPT:libxslt


cd $SOURCE_DIR

URL=https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.14.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ -e /usr/lib/libnssckbi.so ]; then
  readlink /usr/lib/libnssckbi.so ||
  rm -v /usr/lib/libnssckbi.so    &&
  ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
