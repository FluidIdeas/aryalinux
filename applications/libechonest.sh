#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libechonest"
DESCRIPTION="libechonest is a collection of C++/Qt classes designed to make a developer's life easy when trying to use the APIs provided by The Echo Nest."
VERSION="2.3.1"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libe/libechonest/libechonest_2.3.1.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_WITH_QT4=off .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
