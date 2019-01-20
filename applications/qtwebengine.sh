#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:nss
#REQ:python2
#REQ:qt5
#REC:alsa-lib
#REC:pulseaudio
#REC:ffmpeg
#REC:icu
#REC:libwebp
#REC:libxslt
#REC:opus
#OPT:libevent

cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.12/5.12.0/submodules/qtwebengine-everywhere-src-5.12.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/qtwebengine-5.12.0-i686_alignof_fix-1.patch

NAME=qtwebengine
VERSION=5.12.0
URL=https://download.qt.io/archive/qt/5.12/5.12.0/submodules/qtwebengine-everywhere-src-5.12.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

find -type f -name "*.pr[io]" |
xargs sed -i -e 's|INCLUDEPATH += |&$$QTWEBENGINE_ROOT/include |'

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv -v ${QT5DIR}/lib/libQtWebEngineCore.so{,.old}
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

patch -Np1 -i ../qtwebengine-5.12.0-i686_alignof_fix-1.patch
mkdir build &&
cd build &&

qmake .. -- -system-ffmpeg -webengine-icu &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
find $QT5DIR/ -name \*.prl \
-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
