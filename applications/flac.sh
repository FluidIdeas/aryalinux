#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FLAC is an audio CODEC similar tobr3ak MP3, but lossless, meaning that audio is compressed without losingbr3ak any information.br3ak"
SECTION="multimedia"
VERSION=1.3.2
NAME="flac"

#OPT:libogg
#OPT:nasm
#OPT:docbook-utils
#OPT:doxygen
#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/flac/flac-1.3.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/flac/flac-1.3.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.2.tar.xz

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
            --disable-thorough-tests &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
