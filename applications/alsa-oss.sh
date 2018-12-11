#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ALSA OSS package contains thebr3ak ALSA OSS compatibility library. This is used by programs which wishbr3ak to use the ALSA OSS sound interface.br3ak"
SECTION="multimedia"
VERSION=1.1.6
NAME="alsa-oss"

#REQ:alsa-lib


cd $SOURCE_DIR

URL=ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-1.1.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-oss/alsa-oss-1.1.6.tar.bz2

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

sed -i '/#include <libio.h>/d' alsa/stdioemu.c &&
./configure --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
