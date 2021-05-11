#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://ftp.acc.umu.se/pub/gnome/sources/NetworkManager-openconnect/1.2/NetworkManager-openconnect-1.2.6.tar.xz


NAME=network-manager-openconnect
VERSION=1.2.6
URL=https://ftp.acc.umu.se/pub/gnome/sources/NetworkManager-openconnect/1.2/NetworkManager-openconnect-1.2.6.tar.xz
DESCRIPTION="Network Manager plugin for openconnect"

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

if grep "gnome-desktop-environment" /etc/alps/installed-list &> /dev/null; then WITH_GNOME="--with-gnome"; fi
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var $WITH_GNOME &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

