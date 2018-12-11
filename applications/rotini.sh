#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="rotini"
VERSION=SVN
DESCRIPTION="Window Decorator for Fusilli."

#REQ:fusilli

cd $SOURCE_DIR
URL="https://github.com/noodlylight/rotini/archive/master.zip"
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

./autogen.sh --prefix=/usr &&
make -j4
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
