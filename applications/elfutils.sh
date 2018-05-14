#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The elfutils package contains abr3ak set of utilities and libraries for handling ELF (Executable andbr3ak Linkable Format) files.br3ak"
SECTION="general"
VERSION=0.170
NAME="elfutils"

#OPT:valgrind


cd $SOURCE_DIR

URL=https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.170.tar.bz2 || wget -nc ftp://sourceware.org/pub/elfutils/0.170/elfutils-0.170.tar.bz2

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

./configure --prefix=/usr --program-prefix="eu-" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
