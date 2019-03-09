#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:keyutils
#REQ:libcanberra
#REQ:libdaemon
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.30/gdm-3.30.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.30/gdm-3.30.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/gdm-3.30.2-security_fix-1.patch

NAME=gdm
VERSION=3.30.2
URL=http://ftp.gnome.org/pub/gnome/sources/gdm/3.30/gdm-3.30.2.tar.xz

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
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
-g gdm -s /bin/false gdm &&
passwd -ql gdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

patch -Np1 -i ../gdm-3.30.2-security_fix-1.patch &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--without-plymouth \
--disable-static \
--enable-gdm-xsession \
--with-pam-mod-dir=/lib/security &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 data/gdm.service /lib/systemd/system/gdm.service
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable gdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo sed -i "s@#WaylandEnable=false@WaylandEnable=false@g" /etc/gdm/custom.conf
echo "DefaultSession=gnome-xorg.desktop" sudo tee -a /etc/gdm/custom.conf

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
