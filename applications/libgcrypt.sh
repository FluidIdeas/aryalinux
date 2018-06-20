#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libgcrypt package contains abr3ak general purpose crypto library based on the code used inbr3ak GnuPG. The library provides a highbr3ak level interface to cryptographic building blocks using anbr3ak extendable and flexible API.br3ak"
SECTION="general"
VERSION=1.8.3
NAME="libgcrypt"

#REQ:libgpg-error
#OPT:pth
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.3.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.8.3.tar.bz2

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
make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.8.3 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.8.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
