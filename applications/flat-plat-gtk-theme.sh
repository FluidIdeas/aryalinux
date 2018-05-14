#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="flat-plat-gtk-theme"
DESCRIPTION="Flat Plat GTK theme"
VERSION="SVN-`date -I`"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

NAME="flat-plat-gtk-theme"
URL="https://github.com/nana-4/Flat-Plat/archive/master.zip"

wget -c $URL -O flat-plat.zip

sudo mkdir -pv /usr/share/themes/Flat-Plat/
sudo unzip flat-plat.zip -d /usr/share/themes/Flat-Plat/

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
