#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/archive/sdk-1.1.73.0/Vulkan-LoaderAndValidationLayers-sdk-1.1.73.0.tar.gz


NAME=vulkan
VERSION=1.1.73.0
URL=https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/archive/sdk-1.1.73.0/Vulkan-LoaderAndValidationLayers-sdk-1.1.73.0.tar.gz
SECTION="Others"
DESCRIPTION=""

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

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

