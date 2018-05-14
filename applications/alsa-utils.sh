#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ALSA Utilities packagebr3ak contains various utilities which are useful for controlling yourbr3ak sound card.br3ak"
SECTION="multimedia"
VERSION=1.1.6
NAME="alsa-utils"

#REQ:alsa-lib
#OPT:fftw
#OPT:libsamplerate
#OPT:xmlto


cd $SOURCE_DIR

URL=ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.6.tar.bz2

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

./configure --disable-alsaconf \
            --disable-bat   \
            --disable-xmlto \
            --with-curses=ncursesw &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
alsactl -L store

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G audio `cat /tmp/currentuser`





if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
