#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="mongodb-src-r"
DESCRIPTION="MongoDB is an open-source document database and leading NoSQL database. MongoDB is written in C++."
VERSION="3.4.0"

#REQ:scons

cd $SOURCE_DIR

URL=https://fastdl.mongodb.org/src/mongodb-src-r3.4.0.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

scons core --disable-warnings-as-errors -j$(nproc) install &&
sudo cp -v build/opt/mongo/mongo* /usr/bin

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
