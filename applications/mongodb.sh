#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:scons
#REQ:pyyaml


cd $SOURCE_DIR

wget -nc https://fastdl.mongodb.org/src/mongodb-src-r4.2.2.tar.gz


NAME=mongodb
VERSION=4.2.2
URL=https://fastdl.mongodb.org/src/mongodb-src-r4.2.2.tar.gz

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

sudo pip3 install psutil
sudo pip install psutil
sudo pip3 install Cheetah3
sudo pip install Cheetah
scons core --disable-warnings-as-errors -j$(nproc) install &&
sudo cp -v build/opt/mongo/mongo* /usr/bin



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

