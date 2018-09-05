#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak NetworkManager is a set ofbr3ak co-operative tools that make networking simple and straightforward.br3ak Whether WiFi, wired, 3G, or Bluetooth, NetworkManager allows you tobr3ak quickly move from one network to another: Once a network has beenbr3ak configured and joined once, it can be detected and re-joinedbr3ak automatically the next time it's available.br3ak"
SECTION="basicnet"
VERSION=1.10.8
NAME="networkmanager"

#REQ:dbus-glib
#REQ:libndp
#REQ:libnl
#REQ:nss
#REQ:python-modules#pygobject3
#REC:curl
#REC:dhcpcd
#REC:gobject-introspection
#REC:iptables
#REC:newt
#REC:polkit
#REC:python-modules#pygobject3
#REC:systemd
#REC:upower
#REC:vala
#REC:wpa_supplicant
#OPT:bluez
#OPT:gtk-doc
#OPT:qt5
#OPT:ModemManager
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.10/NetworkManager-1.10.8.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.10/NetworkManager-1.10.8.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.10.8.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.10/NetworkManager-1.10.8.tar.xz

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

sed -e '/Qt[CDN]/s/Qt/Qt5/g'       \
    -e 's/moc_location/host_bins/' \
    -i configure


CXXFLAGS="-O2 -fPIC"                                        \
./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --localstatedir=/var                            \
            --with-nmtui                                    \
            --disable-ppp                                   \
            --disable-json-validation                       \
            --disable-ovs                                   \
            --with-udev-dir=/lib/udev                       \
            --with-session-tracking=systemd                 \
            --with-systemdsystemunitdir=/lib/systemd/system \
            --docdir=/usr/share/doc/network-manager-1.10.8 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable NetworkManager

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable NetworkManager-wait-online

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
