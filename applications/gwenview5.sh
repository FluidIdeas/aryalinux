#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Gwenview is a fast and easy-to-usebr3ak image viewer for KDE.br3ak"
SECTION="kde"
VERSION=18.04.1
NAME="gwenview5"

#REQ:exiv2
#REQ:lcms2
#REQ:kframeworks5
#REC:libkdcraw


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/18.04.1/src/gwenview-18.04.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/18.04.1/src/gwenview-18.04.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gwenview/gwenview-18.04.1.tar.xz

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
