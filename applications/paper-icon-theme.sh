#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="paper-icon-theme"
DESCRIPTION="The Paper icon Theme"
VERSION=2.6.4

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL="https://sourceforge.net/projects/aryalinux-bin/files/releases/1.0/artifacts/paper-icon-theme-1.4.0.tar.gz"
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`

wget -nc $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL

cd $DIRECTORY
./autogen.sh --prefix=/usr
make -j$(nproc)
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
