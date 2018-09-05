#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Wget package contains abr3ak utility useful for non-interactive downloading of files from thebr3ak Web.br3ak"
SECTION="basicnet"
VERSION=1.19.5
NAME="wget"

#REC:make-ca
#OPT:gnutls
#OPT:gpgme
#OPT:libidn2
#OPT:pcre
#OPT:python2
#OPT:valgrind


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.19.5.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz

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

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
