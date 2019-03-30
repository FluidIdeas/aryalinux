#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager-pptp/1.2/NetworkManager-pptp-1.2.8.tar.xz

NAME=network-manager-pptp
VERSION=1.2.8
URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager-pptp/1.2/NetworkManager-pptp-1.2.8.tar.xz

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

if grep "gnome-desktop-environment" /etc/alps/installed-list &> /dev/null; then WITH_GNOME="--with-gnome"; fi
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var $WITH_GNOME &&
make
sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
