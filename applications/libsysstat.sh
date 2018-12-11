#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libsysstat package contains abr3ak library used to query system info and statistics.br3ak"
SECTION="lxqt"
VERSION=0.4.0
NAME="libsysstat"

#REQ:cmake
#REQ:lxqt-build-tools
#REQ:qt5


cd $SOURCE_DIR

URL=https://github.com/lxde/libsysstat/releases/download/0.4.0/libsysstat-0.4.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/lxde/libsysstat/releases/download/0.4.0/libsysstat-0.4.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsysstat/libsysstat-0.4.0.tar.xz

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
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
