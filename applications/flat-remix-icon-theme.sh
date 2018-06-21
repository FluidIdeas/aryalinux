#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="flat-remix-icon-theme"
VERSION=20180311
DESCRIPTION="Flat Remix is a flat icon theme for Linux"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/flat-remix-icon-theme.tar.xz
TARBALL=flat-remix-icon-theme.tar.xz
wget -nc $URL
sudo tar xf $TARBALL -C /

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
