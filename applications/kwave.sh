#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The KWave package contains a KF5br3ak based Sound Editor application.br3ak"
SECTION="multimedia"
VERSION=17.12.2
NAME="kwave"

#REQ:audiofile
#REQ:fftw
#REQ:id3lib
#REQ:kframeworks5
#REC:alsa-lib
#REC:flac
#REC:libogg
#REC:pulseaudio
#OPT:doxygen


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/17.12.2/src/kwave-17.12.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/17.12.2/src/kwave-17.12.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kwave/kwave-17.12.2.tar.xz

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

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
