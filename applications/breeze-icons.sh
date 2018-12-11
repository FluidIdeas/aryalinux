#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Breeze Icons package containsbr3ak the default icons for KDE Plasma 5br3ak applications, but it can be used for other window environments.br3ak"
SECTION="x"
VERSION=5.49.0
NAME="breeze-icons"

#REQ:extra-cmake-modules
#REQ:qt5
#OPT:krameworks5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/frameworks/5.49/breeze-icons-5.49.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/frameworks/5.49/breeze-icons-5.49.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.49.0.tar.xz

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
      -DBUILD_TESTING=OFF         \
      -Wno-dev ..



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
