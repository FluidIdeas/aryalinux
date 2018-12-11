#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="numix-gtk-theme"
DESCRIPTION="The Numix GTK Theme"
VERSION=2.6.4

#REQ:gtk2
#REQ:gtk3
#REQ:sass

cd $SOURCE_DIR

URL="https://github.com/numixproject/numix-gtk-theme/archive/2.6.4.tar.gz"
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`

wget -nc $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL

cd $DIRECTORY
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
