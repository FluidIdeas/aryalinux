#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://www.x.org/archive/individual/driver/xf86-video-openchrome-0.6.0.tar.gz
wget -nc https://github.com/freedesktop/openchrome-xf86-video-openchrome/commit/edb46574d4686c59e80569ba236d537097dcdd0e.patch
wget -nc https://github.com/freedesktop/openchrome-xf86-video-openchrome/commit/384cee8312dd9fa84f3f587f4f3a0d5d187d9ab8.patch

NAME=xf86-video-openchrome
VERSION=0.6.0
URL=https://www.x.org/archive/individual/driver/xf86-video-openchrome-0.6.0.tar.gz
DESCRIPTION="Userspace openchrome video graphics driver"

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

patch -Np1 -i ../edb46574d4686c59e80569ba236d537097dcdd0e.patch &&
patch -Np1 -i ../384cee8312dd9fa84f3f587f4f3a0d5d187d9ab8.patch &&
./configure $XORG_CONFIG &&
make -j$(nproc)
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

