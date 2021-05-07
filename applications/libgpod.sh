#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libplist


cd $SOURCE_DIR

wget -nc https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libgpod/0.8.3-16/libgpod_0.8.3.orig.tar.bz2


NAME=libgpod
VERSION=0.8.3
URL=https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libgpod/0.8.3-16/libgpod_0.8.3.orig.tar.bz2
DESCRIPTION="libgpod is a shared library to access the contents of an iPod. This library is based on code used in the gtkpod project."

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
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

