#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/frameworks/5.61/kwindowsystem-5.61.0.tar.xz


NAME=kwindowsystem
VERSION=5.61.0
URL=https://download.kde.org/stable/frameworks/5.61/kwindowsystem-5.61.0.tar.xz
SECTION="LXQT Desktop"
DESCRIPTION="KWindowSystem provides information about the windowing system and allows interaction with the windowing system. It provides an high level API which is windowing system independent and has platform specific implementations. This API is inspired by X11 and thus not all functionality is available on all windowing systems."

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

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

