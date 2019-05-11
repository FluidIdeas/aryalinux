#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:packagekit
#REQ:appstream-glib
#REQ:fwupd

cd $SOURCE_DIR

wget -nc https://ftp.gnome.org/pub/GNOME/sources/gnome-software/3.32/gnome-software-3.32.2.tar.xz

NAME=gnome-software
VERSION=3.32.2
URL=https://ftp.gnome.org/pub/GNOME/sources/gnome-software/3.32/gnome-software-3.32.2.tar.xz

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
meson --prefix=/usr --libdir=/usr/lib --sysconfdir=/etc --mandir=/usr/man ..
ninja
sudo ninja install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
