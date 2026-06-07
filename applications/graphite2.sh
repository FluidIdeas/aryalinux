#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cmake

cd $SOURCE_DIR
NAME=graphite2
VERSION=1.3.14
URL=https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz


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

sed -i '/cmptest/d' tests/CMakeLists.txt
sed -i '/cmake_policy(SET CMP0012 NEW)/d' CMakeLists.txt
sed -i 's/PythonInterp/Python3/' CMakeLists.txt
find . -name CMakeLists.txt | xargs sed -i 's/VERSION 2.8.0 FATAL_ERROR/VERSION 4.0.0/'
sed -i '/Font.h/i #include <cstdint>' tests/featuremap/featuremaptest.cpp
mkdir build
cd    build
cmake -D CMAKE_INSTALL_PREFIX=/usr ..
make
make docs
cp      -v -f    doc/{GTF,manual}.html \
                    /usr/share/doc/graphite2-1.3.14
cp      -v -f    doc/{GTF,manual}.pdf \
                    /usr/share/doc/graphite2-1.3.14


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -d -m755 /usr/share/doc/graphite2-1.3.14
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd