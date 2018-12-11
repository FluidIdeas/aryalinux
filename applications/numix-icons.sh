#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="numix-icons"
VERSION=SVN
DESCRIPTION="Numix is the official icon theme from the Numix Project"


cd $SOURCE_DIR
URL="https://sourceforge.net/projects/aryalinux-bin/files/releases/2016.08/multiarch/Numix-Icons.tar.gz"
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
wget -nc $URL

sudo tar xf $TARBALL -C /usr/share/icons/

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
