#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:lightdm


cd $SOURCE_DIR

wget -nc https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/lightdm-gtk-greeter/2.0.1-2ubuntu4/lightdm-gtk-greeter_2.0.1.orig.tar.gz


NAME=lightdm-gtk-greeter
VERSION=2.0.1
URL=https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/lightdm-gtk-greeter/2.0.1-2ubuntu4/lightdm-gtk-greeter_2.0.1.orig.tar.gz

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

export CFLAGS="-Wno-error=format-nonliteral"
./configure --prefix=/usr --sysconfdir=/etc --disable-liblightdm-qt &&
make "-j`nproc`"

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf << EOF
[greeter]
xft-hintstyle = hintmedium
xft-antialias = true
xft-rgba = rgb
icon-theme-name = 'Flat Remix'
theme-name = Adapta-Nokto
background = /usr/share/backgrounds/aryalinux/default-lock-screen-wallpaper.jpeg
font-name = Droid Sans 10
EOF



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

