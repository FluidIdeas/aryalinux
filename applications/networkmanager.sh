#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus-glib
#REQ:libndp
#REC:curl
#REC:dhcpcd
#REC:dhcp
#REC:gobject-introspection
#REC:iptables
#REC:newt
#REC:nss
#REC:polkit
#REC:pygobject3
#REC:upower
#REC:vala
#REC:wpa_supplicant
#OPT:bluez
#OPT:dbus-python
#OPT:gnutls
#OPT:nss
#OPT:gtk-doc
#OPT:jansson
#OPT:libpsl
#OPT:qt5
#OPT:ModemManager
#OPT:valgrind
#OPT:doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.14/NetworkManager-1.14.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.14/NetworkManager-1.14.4.tar.xz

NAME=networkmanager
VERSION=1.14.4
URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.14/NetworkManager-1.14.4.tar.xz

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

sed -e '/Qt[CDN]/s/Qt/Qt5/g' \
-e 's/-qt4/-qt5/' \
-e 's/moc_location/host_bins/' \
-i examples/C/qt/meson.build
sed '/initrd/d' -i src/meson.build
mkdir build &&
cd build &&

CXXFLAGS+="-O2 -fPIC" \
meson --prefix /usr \
--sysconfdir /etc \
--localstatedir /var \
-Djson_validation=false \
-Dlibaudit=no \
-Dlibnm_glib=true \
-Dlibpsl=false \
-Dnmtui=true \
-Dovs=false \
-Dppp=false \
-Dselinux=false \
-Dqt=false \
-Dudev_dir=/lib/udev \
-Dsession_tracking=systemd \
-Dmodem_manager=false \
-Dsystemdsystemunitdir=/lib/systemd/system \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install &&
mv -v /usr/share/doc/NetworkManager{,-1.14.4}
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
<code class="literal">[main]
plugins=keyfile</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/NetworkManager/conf.d/polkit.conf << "EOF"
<code class="literal">[main]
auth-polkit=true</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > /etc/NetworkManager/conf.d/dhcp.conf << "EOF"
<code class="literal">[main]
dhcp=</code><em class="replaceable"><code>dhclient</code></em>
EOF
cat > /etc/NetworkManager/conf.d/no-dns-update.conf << "EOF"
<code class="literal">[main]
dns=none</code>
EOF

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -fg 86 netdev &&
/usr/sbin/usermod -a -G netdev <em class="replaceable"><code><username></code></em>

cat > /usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
<code class="literal">polkit.addRule(function(action, subject) {
if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
return polkit.Result.YES;
}
});</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable NetworkManager
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable NetworkManager-wait-online
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
