#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="bbswitch_.orig"
VERSION="0.8"

#REQ:dkms

URL=http://archive.ubuntu.com/ubuntu/pool/main/b/bbswitch/bbswitch_0.8.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

pushd $SOURCE_DIR
wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.7.tar.xz
tar xf linux-4.7.tar.xz
cd linux-4.7
cp -v /boot/config* ./.config
make oldconfig
make prepare
make scripts
popd
sudo rm /lib/modules/4.7.0/build
sudo ln -svf $SOURCE_DIR/linux-4.7 /lib/modules/4.7.0/build
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
