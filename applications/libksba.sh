#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Libksba package contains abr3ak library used to make X.509 certificates as well as making the CMSbr3ak (Cryptographic Message Syntax) easily accessible by otherbr3ak applications. Both specifications are building blocks of S/MIME andbr3ak TLS. The library does not rely on another cryptographic library butbr3ak provides hooks for easy integration with Libgcrypt.br3ak"
SECTION="general"
VERSION=1.3.5
NAME="libksba"

#REQ:libgpg-error
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.5.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libksba/libksba-1.3.5.tar.bz2

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
