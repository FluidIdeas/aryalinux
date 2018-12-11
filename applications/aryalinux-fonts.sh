#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-fonts"
VERSION=2016.04
DESCRIPTION="Fonts of the aryalinux XFCE and Mate Desktops"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux-fonts-2016.04.tar.gz
wget -nc $URL

sudo tar xf aryalinux-fonts-2016.04.tar.gz -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
