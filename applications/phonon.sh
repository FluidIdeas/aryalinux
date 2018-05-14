#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Phonon is the multimedia API forbr3ak KDE. It replaces the old aRtsbr3ak package. Phonon needs either the GStreamer or VLC backend.br3ak"
SECTION="kde"
VERSION=4.10.0
NAME="phonon"

#REQ:cmake
#REQ:extra-cmake-modules
#REQ:glib2
#REQ:qt5
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://download.kde.org/stable/phonon/4.10.0/phonon-4.10.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/phonon/4.10.0/phonon-4.10.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.10.0.tar.xz

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
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
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
