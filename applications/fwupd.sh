#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python3-pil
#REQ:libsmbios

cd $SOURCE_DIR

wget -nc https://github.com/hughsie/fwupd/archive/1.2.8.tar.gz

NAME=fwupd
VERSION=1.2.8
URL=https://github.com/hughsie/fwupd/archive/1.2.8.tar.gz

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
meson --prefix=/usr --libdir=/usr/lib --sysconfdir=/etc --mandir=/usr/man -Dman=false -Dplugin_uefi=false -Dplugin_dell=false ..
ninja
sudo ninja install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
