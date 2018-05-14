#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="toluapp"
VERSION=SVN
DESCRIPTION="tolua++ is an extension of toLua, a tool to integrate C/C++ code with Lua"

#REQ:lua
#REQ:cmake

cd $SOURCE_DIR
URL="https://github.com/waltervn/toluapp/archive/master.zip"
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

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo cp -v bin/* /usr/bin/
sudo cp -v lib/* /usr/lib/

sudo ldconfig

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
