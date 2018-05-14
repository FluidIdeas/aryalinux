#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="greybird-gtk-theme"
VERSION=SVN
DESCRIPTION="Desktop Suite for Xfce"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/greybird-gtk-theme.tar.gz

sudo tar xf greybird-gtk-theme.tar.gz -C /

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
