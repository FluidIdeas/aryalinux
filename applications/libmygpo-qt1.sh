#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:qt5
#REQ:gjson


cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc https://github.com/gpodder/libmygpo-qt/archive/1.0.9/libmygpo-qt-1.0.9.tar.gz


NAME=libmygpo-qt1
VERSION=1.0.9
URL=https://github.com/gpodder/libmygpo-qt/archive/1.0.9/libmygpo-qt-1.0.9.tar.gz
DESCRIPTION="C++/Qt Library wrapping the gpodder.net Webservice"

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

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_WITH_QT4=off .. &&
make "-j`nproc`"
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd