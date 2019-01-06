#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:pixman
#REQ:x7font
#REQ:xkeyboard-config
#REC:libepoxy
#REC:wayland
#REC:wayland-protocols
#REC:systemd
#OPT:acpid
#OPT:doxygen
#OPT:fop
#OPT:nettle
#OPT:libgcrypt
#OPT:xcb-util-keysyms
#OPT:xcb-util-image
#OPT:xcb-util-renderutil
#OPT:xcb-util-wm
#OPT:xmlto

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/xserver/xorg-server-1.20.3.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.20.3.tar.bz2

NAME=xorg-server
VERSION=1.20.3.
URL=https://www.x.org/pub/individual/xserver/xorg-server-1.20.3.tar.bz2

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

./configure $XORG_CONFIG          \
            --enable-glamor       \
            --enable-suid-wrapper \
            --with-xkb-output=/var/lib/xkb &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
mkdir -pv /etc/X11/xorg.conf.d
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
