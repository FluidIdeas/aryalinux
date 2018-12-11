#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="audacity_.orig"
VERSION="2.1.2"


#REQ:audio-video-plugins
#REQ:ffmpeg
#REQ:vamp-plugin-sdk
#REQ:wxwidgets

URL=http://archive.ubuntu.com/ubuntu/pool/universe/a/audacity/audacity_2.1.2.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  --disable-dynamic-loading --with-ffmpeg=system
if [ -f /usr/lib/libvamp-hostsdk.la ]
then
	sudo mv /usr/lib/libvamp-hostsdk.la .
elif [ -f /usr/lib64/libvamp-hostsdk.la ]
then
	sudo mv /usr/lib64/libvamp-hostsdk.la .
fi
make "-j`nproc`"
if [ -d /usr/lib64 ]
then
	sudo mv ./libvamp-hostsdk.la /usr/lib64/
elif [ -d /usr/lib ]
then
	sudo mv ./libvamp-hostsdk.la /usr/lib/
fi
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
