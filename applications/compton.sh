#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="compton"
VERSION=0.1
DESCRIPTION="Compton is a compositor for X, and a fork of xcompmgr-dana"

#REQ:x7lib
#REQ:x7app
#REQ:x7proto
#REQ:mesa
#REQ:gtk2
#REQ:gtk3
#REQ:libconfig

cd $SOURCE_DIR
URL="https://github.com/chjj/compton/archive/v0.1_beta2.tar.gz"
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

make
sudo make MANPAGES= install
mkdir -pv ~/.config
sudo mkdir -pv /etc/skel/.config
sed -i 's/menu-opacity = 0.8;/menu-opacity = 1.0;/g' compton.sample.conf
cp -v compton.sample.conf ~/.config/compton.conf
sudo cp -v compton.sample.conf /etc/skel/.config/compton.conf

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
