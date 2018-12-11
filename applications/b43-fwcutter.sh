#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="b43-fwcutter"
VERSION="018"

#REQ:xorg-server

cd $SOURCE_DIR

URL="http://bues.ch/b43/fwcutter/b43-fwcutter-018.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

sed -i "s@/usr/local@/usr@g" Makefile
make
sudo make install

export FIRMWARE_INSTALL_DIR="/lib/firmware"
wget http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
tar xjf broadcom-wl-5.100.138.tar.bz2
sudo b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" broadcom-wl-5.100.138/linux/wl_apsta.o

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
