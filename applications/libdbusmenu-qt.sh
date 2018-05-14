#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This library provides a Qtbr3ak implementation of the DBusMenu specification that exposes menus viabr3ak DBus.br3ak"
SECTION="kde"
VERSION=0.9.3+16.04.20160218
NAME="libdbusmenu-qt"

#REQ:qt5
#OPT:doxygen


cd $SOURCE_DIR

URL=http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz

if [ ! -z $URL ]
then
wget -nc http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz

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
      -DWITH_DOC=OFF              \
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
