#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="conky-manager_2.4~136~ubuntu"
VERSION="16.04.1"

#REQ:conky
#REQ:json-glib
#REQ:rsync
#REQ:p7zip-full
#REQ:libgee

URL=https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/conky-manager_2.4~136~ubuntu16.04.1.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
