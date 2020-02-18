#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/applications/19.08.3/src/kcalc-19.08.3.tar.xz


NAME=kcalc
VERSION=19.08.3
URL=https://download.kde.org/stable/applications/19.08.3/src/kcalc-19.08.3.tar.xz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="DescriptionKCalc is the software calculator integrated with the KDE Software Compilation. In the default view it includes a number pad, buttons for adding, subtracting, multiplying, and dividing, brackets, memory keys, percent, reciprocal, factorial, square, square root, and x to the power of y buttons."

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

