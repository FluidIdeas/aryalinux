#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:qt5
#REQ:jack2
#REQ:ffmpeg
#REQ:pulseaudio


cd $SOURCE_DIR

wget -nc https://github.com/MaartenBaert/ssr/archive/0.3.11.tar.gz


NAME=ssr
VERSION=0.3.11
URL=https://github.com/MaartenBaert/ssr/archive/0.3.11.tar.gz

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

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DWITH_QT5=1 -DWITH_PULSEAUDIO=1 -DWITH_JACK=1 .. &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

