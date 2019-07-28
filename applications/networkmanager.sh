#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:dbus-glib
#REQ:libndp
#REQ:curl
#REQ:dhcpcd
#REQ:gobject-introspection
#REQ:iptables
#REQ:jansson
#REQ:newt
#REQ:nss
#REQ:polkit
#REQ:python-modules#pygobject3
#REQ:systemd
#REQ:upower
#REQ:vala
#REQ:wpa_supplicant


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.18/NetworkManager-1.18.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.18/NetworkManager-1.18.2.tar.xz


NAME=networkmanager
VERSION=1.18.2
URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.18/NetworkManager-1.18.2.tar.xz

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

echo $USER > /tmp/currentuser


sed -e '/Qt[CDN]/s/Qt/Qt5/g'       \
    -e 's/-qt4/-qt5/'              \
    -e 's/moc_location/host_bins/' \
    -i examples/C/qt/meson.build
sed '/initrd/d' -i src/meson.build
grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'
mkdir build &&
cd    build    &&

CXXFLAGS+="-O2 -fPIC"            \
meson --prefix /usr              \
      --sysconfdir /etc          \
      --localstatedir /var       \
      -Djson_validation=false    \
      -Dlibaudit=no              \
      -Dlibnm_glib=true          \
      -Dlibpsl=false             \
      -Dnmtui=true               \
      -Dovs=false                \
      -Dppp=false                \
      -Dselinux=false            \
      -Dqt=false                 \
      -Dudev_dir=/lib/udev       \
      -Dsession_tracking=systemd \
      -Dmodem_manager=false      \
      -Dsystemdsystemunitdir=/lib/systemd/system \
      .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
mv -v /usr/share/doc/NetworkManager{,-1.18.2}
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/NetworkManager/conf.d/polkit.conf << "EOF"
[main]
auth-polkit=true
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -fg 86 netdev &&
/usr/sbin/usermod -a -G netdev $(cat /tmp/currentuser)

cat > /usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable NetworkManager
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable NetworkManager-wait-online
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

