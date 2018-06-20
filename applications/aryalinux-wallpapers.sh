#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-wallpapers"
DESCRIPTION="Wallpapers for AryaLinux"
VERSION="2017.04"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/1.0/aryalinux-wallpapers.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
wget -nc $URL

sudo tar -xf $TARBALL -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
