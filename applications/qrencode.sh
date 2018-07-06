#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=qrencode
URL=https://fukuchi.org/works/qrencode/qrencode-4.0.2.tar.bz2
VERSION=4.0.2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
pushd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

popd

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"



