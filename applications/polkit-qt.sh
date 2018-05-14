#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Polkit-Qt provides an API tobr3ak PolicyKit in the Qt environment.br3ak"
SECTION="kde"
VERSION=0.112.0
NAME="polkit-qt"

#REQ:cmake
#REQ:polkit
#REQ:qt5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2

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
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
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
