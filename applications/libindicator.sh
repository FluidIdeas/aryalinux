#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://launchpad.net/libindicator/12.10/12.10.1/+download/libindicator-12.10.1.tar.gz


NAME=libindicator
VERSION=12.10.1
URL=https://launchpad.net/libindicator/12.10/12.10.1/+download/libindicator-12.10.1.tar.gz
DESCRIPTION="This library contains information to build indicators to go into the indicator applet."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

export CFLAGS+=" -Wno-error=deprecated-declarations" &&
./configure --prefix=/usr --with-gtk=3 --disable-static &&
make &&
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

