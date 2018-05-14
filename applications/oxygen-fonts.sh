#!/bin/bash

set -e
set +h

. /var/lib/alps/functions
. /etc/alps/alps.conf

NAME="oxygen-fonts"
VERSION="5.4.3"
DESCRIPTION="Oxygen Fonts"

URL=https://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz

wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make -j$(nproc)
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

