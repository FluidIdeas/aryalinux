#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fuse


cd $SOURCE_DIR

NAME=libostree
VERSION=2021.3
URL=https://github.com/ostreedev/ostree/releases/download/v2021.3/libostree-2021.3.tar.xz
DESCRIPTION="libostree is a library for managing bootable, immutable, versioned filesystem trees. It is like git in that it checksums individual files and has a content-addressed object store; unlike git, it checks out the files using hardlinks into an immutable directory tree. This can be used to provide atomic upgrades with rollback, history and parallel-installation, particularly useful on fixed purpose systems such as embedded devices. It is also used by the Flatpak application runtime system."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc $URL


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

./configure --prefix=/usr &&
make -j$(nproc)
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd