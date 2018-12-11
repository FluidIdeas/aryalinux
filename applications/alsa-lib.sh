#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ALSA Library package containsbr3ak the ALSA library used by programs (including ALSA Utilities) requiring access to the ALSAbr3ak sound interface.br3ak"
SECTION="multimedia"
VERSION=1.1.6
NAME="alsa-lib"

#OPT:doxygen
#OPT:python2


cd $SOURCE_DIR

URL=ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.6.tar.bz2

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

./configure &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
