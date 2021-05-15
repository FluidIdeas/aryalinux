#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libplist
#REQ:libusbmuxd


cd $SOURCE_DIR

NAME=libimobiledevice
VERSION=1.2.0
URL=http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2
DESCRIPTION="libimobiledevice is a library that talks the native Apple USB protocols that the iPhone, iPad and iPod Touch use. Unlike other projects, libimobiledevice does not depend on using any existing libraries from Apple."


mkdir -pv $NAME
pushd $NAME

wget -nc http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/libimobiledevice-1.2.0-sslv3.patch


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

patch -Np1 -i ../libimobiledevice-1.2.0-sslv3.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd