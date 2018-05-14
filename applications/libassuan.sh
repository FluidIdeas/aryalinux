#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libassuan package contains anbr3ak inter process communication library used by some of the otherbr3ak GnuPG related packages.br3ak libassuan's primary use is tobr3ak allow a client to interact with a non-persistent server.br3ak libassuan is not, however, limitedbr3ak to use with GnuPG servers andbr3ak clients. It was designed to be flexible enough to meet the demandsbr3ak of many transaction based environments with non-persistent servers.br3ak"
SECTION="general"
VERSION=2.5.1
NAME="libassuan"

#REQ:libgpg-error
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.5.1.tar.bz2

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
