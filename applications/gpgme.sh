#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GPGME package is a C librarybr3ak that allows cryptography support to be added to a program. It isbr3ak designed to make access to public key crypto engines likebr3ak GnuPG or GpgSM easier forbr3ak applications. GPGME provides abr3ak high-level crypto API for encryption, decryption, signing,br3ak signature verification and key management.br3ak"
SECTION="postlfs"
VERSION=1.11.1
NAME="gpgme"

#REQ:libassuan
#OPT:doxygen
#REQ:gnupg
#OPT:clisp
#OPT:python2
#OPT:qt5
#OPT:swig


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.11.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gpgme/gpgme-1.11.1.tar.bz2

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

./configure --prefix=/usr --disable-gpg-test --disable-gpgconf-test --disable-gpgsm-test --disable-g13-test &&
make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
