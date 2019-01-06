#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gnome-settings-daemon
#REQ:itstool
#REQ:libdvdread
#REQ:libpwquality
#REQ:libsecret
#REQ:udisks2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.28/gnome-disk-utility-3.28.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.28/gnome-disk-utility-3.28.3.tar.xz

NAME=gnome-disk-utility
VERSION=3.28.3
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.28/gnome-disk-utility-3.28.3.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir build &&
cd build &&

meson --prefix=/usr --sysconfdir=/etc &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
