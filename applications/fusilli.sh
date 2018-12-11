#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="fusilli"
VERSION=SVN
DESCRIPTION="Fusilli is an OpenGL compositing window manager for the X Window System. It is a fork of Compiz (0.8)."

#REQ:startup-notification
#REQ:python-modules#py2cairo
#REQ:python-modules#pygobject2
#REQ:git
#REQ:pyrex

cd $SOURCE_DIR
URL="https://github.com/noodlylight/fusilli/archive/master.zip"
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

./autogen.sh --prefix=/usr --disable-marco &&
make -j4
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
