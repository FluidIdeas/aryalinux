#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Falkon is a KDE web browser usingbr3ak the QtWebEngine rendering engine. It was previously known asbr3ak QupZilla. It aims to be abr3ak lightweight web browser available through all major platforms.br3ak"
SECTION="xsoft"
VERSION=3.0.1
NAME="falkon"

#REQ:extra-cmake-modules
#REQ:qtwebengine
#OPT:gnome-keyring
#OPT:krameworks5


cd $SOURCE_DIR

URL=https://download.kde.org/stable/falkon/3.0.1/falkon-3.0.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.kde.org/stable/falkon/3.0.1/falkon-3.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/falkon/falkon-3.0.1.tar.xz

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

rm -rf po/


sed -i 's/"5.11.", 5) == 0 ? 1 : 2/"5.10.", 5) >= 0 ? 2 : 1/' \
  autotests/webviewtest.cpp


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TESTING=OFF         \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
