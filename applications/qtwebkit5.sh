#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qtwebkit is a Qt based web browserbr3ak engine.br3ak"
SECTION="x"
VERSION=5.9.0
NAME="qtwebkit5"

#REQ:icu
#REQ:libjpeg
#REQ:libpng
#REQ:libwebp
#REQ:libxslt
#REQ:qt5
#REQ:ruby
#REQ:sqlite
#REC:gst10-plugins-base


cd $SOURCE_DIR

URL=https://download.qt.io/community_releases/5.9/5.9.0-final/qtwebkit-opensource-src-5.9.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.qt.io/community_releases/5.9/5.9.0-final/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.9.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/qtwebkit-5.9.0-icu_59-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/qt/qtwebkit-5.9.0-icu_59-1.patch

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

patch -Np1 -i ../qtwebkit-5.9.0-icu_59-1.patch


sed -e '/CONFIG/a QMAKE_CXXFLAGS += -Wno-expansion-to-defined' \
    -i Tools/qmake/mkspecs/features/unix/default_pre.prf


mkdir -p build        &&
cd       build        &&
qmake ../WebKit.pro   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/qt5/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
