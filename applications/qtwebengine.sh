#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cups
#REQ:pciutils

cd $SOURCE_DIR
NAME=qtwebengine
VERSION=6.10.2
URL=https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwebengine-everywhere-src-6.10.2.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwebengine-everywhere-src-6.10.2.tar.xz


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

sed -e '/ifndef SYS_SECCOMP/,+2 d' \
    -i src/3rdparty/chromium/sandbox/linux/system_headers/linux_seccomp.h
mkdir build
cd    build
cmake -D CMAKE_MESSAGE_LOG_LEVEL=STATUS             \
      -D QT_FEATURE_webengine_system_ffmpeg=ON      \
      -D QT_FEATURE_webengine_system_icu=ON         \
      -D QT_FEATURE_webengine_proprietary_codecs=ON \
      -D QT_FEATURE_webengine_webrtc_pipewire=ON    \
      -D QT_BUILD_EXAMPLES_BY_DEFAULT=OFF           \
      -D QT_GENERATE_SBOM=OFF                       \
      -G Ninja ..
ninja


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd