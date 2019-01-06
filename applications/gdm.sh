#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libcanberra
#REQ:libdaemon
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.28/gdm-3.28.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.28/gdm-3.28.3.tar.xz

NAME=gdm
VERSION=3.28.3
URL=http://ftp.gnome.org/pub/gnome/sources/gdm/3.28/gdm-3.28.3.tar.xz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm &&
passwd -ql gdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --without-plymouth    \
            --disable-static      \
            --enable-gdm-xsession \
            --with-pam-mod-dir=/lib/security &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m644 data/gdm.service /lib/systemd/system/gdm.service
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable gdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
