#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:curl
#REQ:libevent
#REC:gtk3

cd $SOURCE_DIR

wget -nc https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz

NAME=transmission
VERSION=2.94
URL=https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
