#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak MLT package is the Media Lovinbr3ak Toolkit. It is an open source multimedia framework, designed andbr3ak developed for television broadcasting. It provides a toolkit forbr3ak broadcasters, video editors, media players, transcoders, webbr3ak streamers and many more types of applications.br3ak"
SECTION="multimedia"
VERSION=6.6.0
NAME="mlt"



cd $SOURCE_DIR

URL=https://github.com/mltframework/mlt/releases/download/v6.6.0/mlt-6.6.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/mltframework/mlt/releases/download/v6.6.0/mlt-6.6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mlt/mlt-6.6.0.tar.gz

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

./configure --prefix=/usr            \
            --enable-gpl             \
            --enable-gpl3            \
            --enable-opengl          \
            --disable-gtk2           \
            --qt-libdir=/opt/qt5/lib  \
            --qt-includedir=/opt/qt5/include &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
