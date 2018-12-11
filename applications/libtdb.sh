#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libtdb
VERSION=1.3.14
DESCRIPTION="libtdb is a simple database API. It was inspired by the realisation that in Samba we have several ad-hoc bits of code that essentially implement small databases for sharing structures between parts of Samba."

cd $SOURCE_DIR

URL="https://www.samba.org/ftp/tdb/tdb-1.3.14.tar.gz"
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
