#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lightdm-gtk-greeter
VERSION=2.0.1
DESCRIPTION="GTK Based greeter for lightdm display manager"

#REQ:xserver-meta
#REQ:itstool
#REQ:libgcrypt
#REQ:libxklavier
#REQ:systemd
#REQ:polkit
#REQ:lightdm
#REQ:greybird-gtk-theme
#REQ:aryalinux-wallpapers
#REC:aryalinux-fonts

cd $SOURCE_DIR

URL="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/lightdm-gtk-greeter/2.0.1-2ubuntu4/lightdm-gtk-greeter_2.0.1.orig.tar.gz"
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -nc $URL
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
tar -xf $TARBALL
cd $DIRECTORY

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
icon-theme-name = Numix-Circle
theme-name = Greybird
background = /usr/share/backgrounds/aryalinux/pexels-photo-459059.jpeg
font-name = Droid Sans 10
EOF

 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
