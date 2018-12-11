#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="An application to take screenshots. Default screenshot application for XFCE"
NAME="xfce4-screenshooter"
VERSION="1.9.2"

#REQ:libsoup
#REQ:xfce4-dev-tools

KDE_PREFIX=/usr
cd $SOURCE_DIR

URL=https://git.xfce.org/apps/xfce4-screenshooter/snapshot/xfce4-screenshooter-1.9.2.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh --prefix=/usr
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
