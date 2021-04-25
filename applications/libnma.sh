#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:networkmanager
#REQ:mobile-broadband-provider-info


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/libnma/1.8/libnma-1.8.28.tar.xz


NAME=libnma
VERSION=1.8.28
URL=https://download.gnome.org/sources/libnma/1.8/libnma-1.8.28.tar.xz
SECTION="Networking Utilities"
DESCRIPTION="The libnma package contains an implementation of the NetworkManager GUI functions."

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

meson --prefix=/usr --disable-gtk-doc &&
ninja

sudo ninja install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

