#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde-apps"
VERSION=17.04.1
NAME="pim-sieve-editor"

#REQ:plasma-all


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/17.04.1/src/pim-sieve-editor-17.04.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/17.04.1/src/pim-sieve-editor-17.04.1.tar.xz

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

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DLIB_INSTALL_DIR=lib -DBUILD_TESTING=OFF -Wno-dev .. &&
make -j$(nproc)
sudo make install




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
