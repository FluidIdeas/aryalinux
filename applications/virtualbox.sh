#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:qt5

NAME=virtualbox
VERSION=5.2.14

cd $SOURCE_DIR

export KERNEL_VERSION=$(uname -r)

if [ `uname -m` == "x86_64" ]
then
	URL=https://download.virtualbox.org/virtualbox/5.2.14/VirtualBox-5.2.14-123301-Linux_amd64.run
else
	URL=https://download.virtualbox.org/virtualbox/5.2.14/VirtualBox-5.2.14-123301-Linux_x86.run
fi

KERNEL_URL=https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
KERNEL_TARBALL=$(echo $KERNEL_URL | rev | cut -d/ -f1 | rev)
VBOX_INSTALLER=$(echo $URL | rev | cut -d/ -f1 | rev)

wget -nc $URL
wget -nc $KERNEL_URL

KERNEL_DIR=$(tar tf $KERNEL_TARBALL | cut -d/ -f1 | uniq)

mkdir -pv /usr/src/
sudo tar xf $KERNEL_TARBALL -C /usr/src
sudo ln -svf /usr/src/$KERNEL_DIR /lib/modules/$KERNEL_VERSION/build

pushd /usr/src/$KERNEL_DIR
sudo make oldconfig
sudo make prepare
sudo make scripts
popd

chmod a+x $VBOX_INSTALLER

sudo ./$VBOX_INSTALLER

sudo ln -svf /opt/VirtualBox/virtualbox.desktop /usr/share/applications/
sudo update-desktop-database
sudo update-mime-database /usr/share/mime

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
