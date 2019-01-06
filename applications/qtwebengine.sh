#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

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

NAME=qtwebengine
VERSION=5.12.0
URL=https://download.qt.io/archive/qt/5.12/5.12.0/submodules/qtwebengine-everywhere-src-5.12.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

find -type f -name "*.pr[io]" |
  xargs sed -i -e 's|INCLUDEPATH += |&$$QTWEBENGINE_ROOT/include |'

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mv -v ${QT5DIR}/lib/libQtWebEngineCore.so{,.old}
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

mkdir build &&
cd    build &&

qmake -- -system-ffmpeg -webengine-icu .. &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
find $QT5DIR/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
