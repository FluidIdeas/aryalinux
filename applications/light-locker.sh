#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="light-locker"
VERSION="1.7.0"

#REQ:gnome-common
#REQ:lightdm
#REQ:systemd
#REQ:upower

cd $SOURCE_DIR

URL=https://github.com/the-cavalry/light-locker/releases/download/v1.7.0/light-locker-1.7.0.tar.bz2

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
