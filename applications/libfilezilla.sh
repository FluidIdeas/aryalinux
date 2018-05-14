#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

URL=http://sourceforge.net/projects/filezilla/files/libfilezilla/0.6.0/libfilezilla-0.6.0.tar.bz2/download

cd $SOURCE_DIR

wget -nc $URL -O libfilezilla-0.6.0.tar.bz2
TARBALL=libfilezilla-0.6.0.tar.bz2
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
