#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="obexftp--Source"
VERSION="0.24.2"

cd $SOURCE_DIR

URL="https://sourceforge.net/projects/openobex/files/obexftp/0.24.2/obexftp-0.24.2-Source.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
