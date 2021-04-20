#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:nss
#REQ:python2
#REQ:qt5
#REQ:alsa-lib
#REQ:pulseaudio
#REQ:ffmpeg
#REQ:icu
#REQ:libwebp
#REQ:libxslt
#REQ:opus


cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.15/5.15.2/submodules/qtwebengine-everywhere-src-5.15.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/qtwebengine-everywhere-src-5.15.2-ICU68-2.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/qtwebengine-everywhere-src-5.15.2-glibc233-1.patch


NAME=qtwebengine
VERSION=5.15.2
URL=https://download.qt.io/archive/qt/5.15/5.15.2/submodules/qtwebengine-everywhere-src-5.15.2.tar.xz
SECTION="X Libraries"
DESCRIPTION="QtWebEngine integrates chromium's web capabilities into Qt. It ships with its own copy of ninja which it uses for the build if it cannot find a system copy, and various copies of libraries from ffmpeg, icu, libvpx, and zlib (including libminizip) which have been forked by the chromium developers."

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

echo $USER > /tmp/currentuser


find -type f -name "*.pr[io]" |
  xargs sed -i -e 's|INCLUDEPATH += |&$$QTWEBENGINE_ROOT/include |'
patch -Np1 -i ../qtwebengine-everywhere-src-5.15.2-ICU68-2.patch
patch -Np1 -i ../qtwebengine-everywhere-src-5.15.2-glibc233-1.patch
sed -e '/link_pulseaudio/s/false/true/' \
    -i src/3rdparty/chromium/media/media_options.gni
sed -i 's/NINJAJOBS/NINJA_JOBS/' src/core/gn_run.pro
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ -e ${QT5DIR}/lib/libQt5WebEngineCore.so ]; then
  mv -v ${QT5DIR}/lib/libQt5WebEngineCore.so{,.old}
fi
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir build &&
cd    build &&

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

