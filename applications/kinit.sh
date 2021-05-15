#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake

cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/frameworks/5.82/kinit-5.82.0.tar.xz

NAME=kinit
VERSION=5.82.0
URL=https://download.kde.org/stable/frameworks/5.82/kinit-5.82.0.tar.xz
SECTION="KDE Plasma 5"

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


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make
sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"


