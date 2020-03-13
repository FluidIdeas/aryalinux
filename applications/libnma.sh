#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libnma/1.8/libnma-1.8.28.tar.xz


NAME=libnma
VERSION=1.8.28
URL=ftp://ftp.gnome.org/pub/gnome/sources/libnma/1.8/libnma-1.8.28.tar.xz
SECTION="Networking Utilities"
DESCRIPTION="LibreOffice is a full-featured office suite. It is largely compatible with Microsoft Office and is descended from OpenOffice.org."

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

