#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:xorg-server


cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2


NAME=xorg-vmmouse-driver
VERSION=13.1.0
URL=https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

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

./configure $XORG_CONFIG --without-hal-fdi-dir --without-hal-callouts-dir --with-udev-rules-dir=/lib/udev/rules.d && make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

