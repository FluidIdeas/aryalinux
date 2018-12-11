#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="openvpn"
VERSION="2.4.4"

#REQ:liblzo2
#REQ:net-tools

URL=https://swupdate.openvpn.org/community/releases/openvpn-2.4.4.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --enable-systemd &&
make "-j`nproc`"
sudo make install
sudo mkdir -pv /var/run/openvpn/
sudo cp ./distro/systemd/openvpn-client@.service /lib/systemd/system/
sudo cp ./distro/systemd/openvpn-server@.service /lib/systemd/system/
sudo systemctl enable openvpn-client@.service

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
