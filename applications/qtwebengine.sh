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
#REQ:python-modules#jinja2
#REQ:icu
#REQ:libwebp
#REQ:libxslt
#REQ:opus


cd $SOURCE_DIR

wget -nc https://download.qt.io/archive/qt/5.13/5.13.2/submodules/qtwebengine-everywhere-src-5.13.2.tar.xz


NAME=qtwebengine
VERSION=5.13.2
URL=https://download.qt.io/archive/qt/5.13/5.13.2/submodules/qtwebengine-everywhere-src-5.13.2.tar.xz

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
sed -e '/!buffer/a \
\    BaseAudioContext::GraphAutoLocker context_locker(Context()); \
\    MutexLocker locker(process_lock_);' -i \
     src/3rdparty/chromium/third_party/blink/renderer/modules/webaudio/convolver_node.cc
sed -e '/link_pulseaudio/s/false/true/' \
    -i src/3rdparty/chromium/media/media_options.gni
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

