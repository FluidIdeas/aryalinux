#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="t1lib"
VERSION="5.1.2"

cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/t1lib/t1lib-5.1.2.tar.gz/a5629b56b93134377718009df1435f3c/t1lib-5.1.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -nc $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`" without_doc

sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
