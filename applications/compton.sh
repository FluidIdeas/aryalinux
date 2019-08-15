#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/chjj/compton/archive/v0.1_beta2.tar.gz


NAME=compton
VERSION=0.1
URL=https://github.com/chjj/compton/archive/v0.1_beta2.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

make
sudo make install
mkdir -pv ~/.config
sudo mkdir -pv /etc/skel/.config
sed -i 's/menu-opacity = 0.8;/menu-opacity = 1.0;/g' compton.sample.conf
cp -v compton.sample.conf ~/.config/compton.conf
sudo cp -v compton.sample.conf /etc/skel/.config/compton.conf


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

