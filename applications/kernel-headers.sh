#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR



NAME=kernel-headers
VERSION=current

DESCRIPTION="The current linux kernel headers."

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

KERNEL_VERSION=$(uname -r)
KERNEL_MAJOR_VERSION=$(uname -r | cut -d '.' -f1)
KERNEL_URL=https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_VERSION.tar.xz
KERNEL_TARBALL=$(echo $KERNEL_URL | rev | cut -d/ -f1 | rev)

wget -nc $KERNEL_URL

KERNEL_DIR=$(tar tf $KERNEL_TARBALL | cut -d/ -f1 | uniq)

sudo mkdir -pv /usr/src/
sudo tar xf $KERNEL_TARBALL -C /usr/src
sudo ln -svf /usr/src/$KERNEL_DIR /lib/modules/$KERNEL_VERSION/build

pushd /usr/src/$KERNEL_DIR
sudo make oldconfig
sudo make prepare
sudo make scripts
popd

sudo rm -rf $KERNEL_TARBALL

VERSION=$KERNEL_VERSION



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

