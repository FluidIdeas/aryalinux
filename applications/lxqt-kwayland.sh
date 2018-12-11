#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Kwayland is a Qt-style API tobr3ak interact with the wayland-clientbr3ak and wayland-server API.br3ak"
SECTION="lxqt"
VERSION=5.46.0
NAME="lxqt-kwayland"

#REQ:extra-cmake-modules
#REQ:mesa
#REQ:wayland
#REQ:qt5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/frameworks/5.46/kwayland-5.46.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/frameworks/5.46/kwayland-5.46.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kwayland/kwayland-5.46.0.tar.xz

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
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX                          \
      -DCMAKE_BUILD_TYPE=Release                                   \
      -DBUILD_TESTING=OFF                                          \
      -DECM_MKSPECS_INSTALL_DIR=$LXQT_PREFIX/share/mkspecs/modules \
      -Wno-dev ..                                                  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
