#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:llvm
#REQ:alsa-lib
#REQ:glu
#REQ:libjpeg


cd $SOURCE_DIR

wget -nc https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.18.0.tar.bz2


NAME=v4l-utils
VERSION=1.18.0
URL=https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.18.0.tar.bz2
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="v4l-utils provides a series of utilities for media devices, allowing to handle the proprietary formats available at most webcams (libv4l), and providing tools to test V4L devices."

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

echo $USER > /tmp/currentuser


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

