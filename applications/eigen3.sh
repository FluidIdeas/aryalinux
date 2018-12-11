#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="eigen3"
DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms."
VERSION="3.3.1"

cd $SOURCE_DIR

URL=http://bitbucket.org/eigen/eigen/get/3.3.1.tar.bz2
TARBALL=$NAME-$VERSION.tar.bz2

wget -c $URL -O $TARBALL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
