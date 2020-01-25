#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/applications/19.08.0/src/kate-19.08.0.tar.xz


NAME=kate
VERSION=19.08.0
URL=https://download.kde.org/stable/applications/19.08.0/src/kate-19.08.0.tar.xz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="DescriptionThe KDE Advanced Text Editor is a text editor developed by the KDE free software community. It has been a part of KDE Software Compilation since version 2.2, which was first released in 2001."

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
make -j$(nproc)

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

