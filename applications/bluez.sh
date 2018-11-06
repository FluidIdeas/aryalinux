#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The BlueZ package contains thebr3ak Bluetooth protocol stack for Linux.br3ak"
SECTION="general"
VERSION=5.50
NAME="bluez"

#REQ:dbus
#REQ:glib2
#REQ:libical


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/bluetooth/bluez-5.50.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/bluetooth/bluez-5.50.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluez/bluez-5.50.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/bluez/bluez-5.50.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.50.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.50.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.50.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.50.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --enable-library      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf ../libexec/bluetooth/bluetoothd /usr/sbin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/bluetooth &&
install -v -m644 src/main.conf /etc/bluetooth/main.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/bluez-5.50 &&
install -v -m644 doc/*.txt /usr/share/doc/bluez-5.50

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/bluetooth/rfcomm.conf << "EOF"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/bluetooth/uart.conf << "EOF"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable bluetooth

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable --global obex

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
