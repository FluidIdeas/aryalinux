#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="xfce4-datetime-plugin"
VERSION="0.7.0"

#REQ:libxfcegui4

KDE_PREFIX=/usr
cd $SOURCE_DIR

URL=https://git.xfce.org/panel-plugins/xfce4-datetime-plugin/snapshot/xfce4-datetime-plugin-datetime-0.7.0.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
