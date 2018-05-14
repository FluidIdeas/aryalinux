#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="conky"
VERSION=SVN
DESCRIPTION="Conky is a free, light-weight system monitor for X, that displays any kind of information on your desktop."

#REQ:xserver-meta
#REQ:cmake
#REQ:git
#REQ:lua
#REQ:toluapp
#REQ:imlib2
#REQ:librsvg

cd $SOURCE_DIR
URL="https://github.com/brndnmtthws/conky/archive/master.zip"
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
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s " " | cut -d " " -f1 | rev | cut -d/ -f1 | uniq)
unzip -o $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_IMLIB2=ON -DBUILD_LUA_CAIRO=ON -DBUILD_LUA_IMLIB2=ON -DBUILD_LUA_RSVG=ON -DBUILD_XDBE=ON -DBUILD_XSHAPE=ON .
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
