#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk3
#REQ:libgcrypt
#REQ:linux-pam
#REQ:pcre
#REQ:itstool
#REC:gobject-introspection
#REC:libxklavier
#REC:vala
#OPT:at-spi2-core
#OPT:exo
#OPT:gtk-doc
#OPT:itstool
#OPT:qt5

cd $SOURCE_DIR

wget -nc https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz
wget -nc https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.5/+download/lightdm-gtk-greeter-2.0.5.tar.gz

NAME=lightdm
VERSION=1.28.0
URL=https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 65 lightdm &&
useradd -c "Lightdm Daemon" \
-d /var/lib/lightdm \
-u 65 -g lightdm \
-s /bin/false lightdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

./configure \
--prefix=/usr \
--libexecdir=/usr/lib/lightdm \
--localstatedir=/var \
--sbindir=/usr/bin \
--sysconfdir=/etc \
--disable-static \
--disable-tests \
--with-greeter-user=lightdm \
--with-greeter-session=lightdm-gtk-greeter \
--docdir=/usr/share/doc/lightdm-1.28.0 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
cp tests/src/lightdm-session /usr/bin &&
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session &&
rm -rf /etc/init &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm &&
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

tar -xf ../lightdm-gtk-greeter-2.0.5.tar.gz &&
cd lightdm-gtk-greeter-2.0.5 &&

./configure \
--prefix=/usr \
--libexecdir=/usr/lib/lightdm \
--sbindir=/usr/bin \
--sysconfdir=/etc \
--with-libxklavier \
--enable-kill-on-sigterm \
--disable-libido \
--disable-libindicator \
--disable-static \
--docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.5 &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-lightdm
sudo systemctl enable lightdm
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105

sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf << EOF
[greeter]
xft-hintstyle = hintmedium
xft-antialias = true
xft-rgba = rgb
icon-theme-name = 'Flat Remix'
theme-name = Greybird
background = /usr/share/backgrounds/aryalinux/default-lock-screen-wallpaper.jpeg
font-name = Droid Sans 10
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
