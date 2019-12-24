#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:net-tools


cd $SOURCE_DIR

wget -nc https://swupdate.openvpn.org/community/releases/openvpn-2.4.8.tar.gz


NAME=openvpn
VERSION=2.4.8
URL=https://swupdate.openvpn.org/community/releases/openvpn-2.4.8.tar.gz

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

if grep "gnome-desktop-environment" /etc/alps/installed-list &> /dev/null; then export WITH_GNOME="--with-gnome"; fi
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var $WITH_GNOME &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

