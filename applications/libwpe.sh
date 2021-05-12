#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/WebPlatformForEmbedded/libwpe/releases/download/1.10.0/libwpe-1.10.0.tar.xz


NAME=libwpe
VERSION=1.10.0
URL=https://github.com/WebPlatformForEmbedded/libwpe/releases/download/1.10.0/libwpe-1.10.0.tar.xz
SECTION="Others"
DESCRIPTION="General-purpose library specifically developed for the WPE-flavored port of WebKit."

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

mkdir build
cd build

meson --prefix=/usr &&
ninja

sudo ninja install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
