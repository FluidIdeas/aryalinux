#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Libkscreen package containsbr3ak the KDE Screen Management library.br3ak"
SECTION="lxqt"
VERSION=5.12.5
NAME="lxqt-libkscreen"

#REQ:lxqt-kwayland


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.12.5/libkscreen-5.12.5.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/plasma/5.12.5/libkscreen-5.12.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.12.5.tar.xz

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

export QT5DIR=/opt/qt5
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin           PATH
pathappend /opt/lxqt/share/man/    MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins   QT_PLUGIN_PATH
pathappend $QT5DIR/plugins         QT_PLUGIN_PATH
pathappend /opt/lxqt/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
