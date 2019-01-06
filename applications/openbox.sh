#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:installing
#REQ:pango
#OPT:dbus
#OPT:imlib2
#OPT:imagemagick
#OPT:pyxdg
#OPT:startup-notification
#OPT:librsvg

cd $SOURCE_DIR

wget -nc http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz
wget -nc http://ftp.de.debian.org/debian/pool/main/n/numlockx/numlockx_1.2.orig.tar.gz

NAME=openbox
VERSION=3.6.1
URL=http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz

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

export LIBRARY_PATH=$XORG_PREFIX/lib
2to3 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
