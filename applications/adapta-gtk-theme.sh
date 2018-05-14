#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION=20180311

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/adapta-gtk-theme.tar.xz
TARBALL="adapta-gtk-theme.tar.xz"
wget -c $URL
sudo tar xf $TARBALL -C /

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
