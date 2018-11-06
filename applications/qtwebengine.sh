#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak QtWebEngine integratesbr3ak chromium\"s web capabilities intobr3ak Qt. It ships with its own copy of ninja which it uses for the buildbr3ak if it cannot find a system copy, and various copies of librariesbr3ak from ffmpeg, icu, libvpx, and zlib (including libminizip) whichbr3ak have been forked by the chromiumbr3ak developers.br3ak"
SECTION="x"
VERSION=5.11.2
NAME="qtwebengine"

#REQ:nss
#REQ:pulseaudio
#REQ:qt5
#REC:libwebp
#REC:libxslt
#REC:opus
#OPT:libevent


cd $SOURCE_DIR

URL=https://download.qt.io/archive/qt/5.11/5.11.2/submodules/qtwebengine-everywhere-src-5.11.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.qt.io/archive/qt/5.11/5.11.2/submodules/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebengine/qtwebengine-everywhere-src-5.11.2.tar.xz

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
qmake ..    &&
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
