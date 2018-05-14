#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Simple DirectMedia Layer (SDLbr3ak for short) is a cross-platform library designed to make it easy tobr3ak write multimedia software, such as games and emulators.br3ak"
SECTION="multimedia"
VERSION=1.2.15
NAME="sdl"

#OPT:aalib
#OPT:glu
#OPT:nasm
#OPT:pulseaudio
#OPT:pth
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://www.libsdl.org/release/SDL-1.2.15.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.libsdl.org/release/SDL-1.2.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz

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

sed -e '/_XData32/s:register long:register _Xconst long:' \
    -i src/video/x11/SDL_x11sym.h &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/SDL-1.2.15/html &&
install -v -m644    docs/html/*.html \
                    /usr/share/doc/SDL-1.2.15/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd test &&
./configure &&
make "-j`nproc`" || make




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
