#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="simple-scan"
VERSION="3.25.1"

#REQ:packagekit
#REQ:sane
#REQ:itstool

cd $SOURCE_DIR

URL=https://launchpad.net/simple-scan/3.25/3.25.1/+download/simple-scan-3.25.1.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&
meson --prefix=/usr         \
      --sysconfdir=/etc     \
      --localstatedir=/var &&
ninja
sudo ninja install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
