#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="yajl"
VERSION=SVN
DESCRIPTION="A fast streaming JSON parsing library in C"


cd $SOURCE_DIR
URL="https://github.com/lloyd/yajl/archive/master.zip"
if [ ! -z $(echo $URL | grep "/master.zip$") ] && [ ! -f $NAME-master.zip ]; then
	wget -nc $URL -O $NAME-master.zip
	TARBALL=$NAME-master.zip
elif [ ! -z $(echo $URL | grep "/master.zip$") ] && [ -f $NAME-master.zip ]; then
	echo "Tarball already downloaded. Skipping."
	TARBALL=$NAME-master.zip
else
	wget -nc $URL
	TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
fi
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s ' ' | cut -d ' ' -f1 | rev | cut -d/ -f1 | uniq)
unzip -o $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make "-j`nproc`" yajl
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
