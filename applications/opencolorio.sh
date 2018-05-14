#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="v"
VERSION="1.0.8"

#REQ:openimageio

URL=http://github.com/imageworks/OpenColorIO/tarball/v1.0.8

cd $SOURCE_DIR

wget -nc $URL

tar -xf v1.0.8
cd imageworks-OpenColorIO-8883824

cmake -DCMAKE_INSTALL_PREFIX=/usr . &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf imageworks-OpenColorIO-8883824

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
