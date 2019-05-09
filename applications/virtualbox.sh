#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc https://download.virtualbox.org/virtualbox/6.0.6/VirtualBox-6.0.6-130049-Linux_amd64.run
wget -nc https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.0.11.tar.xz

NAME=virtualbox
VERSION=6.0.6
URL=https://download.virtualbox.org/virtualbox/6.0.6/VirtualBox-6.0.6-130049-Linux_amd64.run

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

sudo tar xf linux-5.0.11.tar.xz -C /usr/src/
sudo mv /usr/src/linux-5.0.11 /usr/src/linux
sudo ln -svf /usr/src/linux /lib/modules/5.0.11/build
pushd /usr/src/linux
sudo make oldconfig
sudo make prepare
sudo make scripts
popd
chmod a+x *run
sudo ./VirtualBox-6.0.6-130049-Linux_amd64.run
pushd /usr/src/linux
sudo make clean
popd

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
