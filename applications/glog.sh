#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="glog"
URL=https://github.com/google/glog/archive/v0.3.4.tar.gz

cd $SOURCE_DIR
wget -nc $URL -O glog-0.3.4.tar.gz

TARBALL=glog-0.3.4.tar.gz
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
