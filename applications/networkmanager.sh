#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:dbus-glib
#REQ:libndp
#REQ:libnl
#REQ:nss
#REC:curl
#REC:dhcpcd
#REC:dhcp
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
#OPT:jansson
#OPT:libpsl
#OPT:qt5
#OPT:ModemManager
#OPT:valgrind
#OPT:doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.12/NetworkManager-1.12.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.12/NetworkManager-1.12.2.tar.xz

URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.12/NetworkManager-1.12.2.tar.xz

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

sed -e '/Qt[CDN]/s/Qt/Qt5/g'       \
    -e 's/moc_location/host_bins/' \
    -i configure
sed -i 's/1,12,2/1,12.2/' libnm-core/nm-version.h &&
CXXFLAGS="-O2 -fPIC"                                        \
./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --localstatedir=/var                            \
            --with-nmtui                                    \
            --with-libnm-glib                               \
            --disable-ppp                                   \

            --with-udev-dir=/lib/udev                       \
            --with-session-tracking=systemd                 \
            --with-systemdsystemunitdir=/lib/systemd/system \
            --docdir=/usr/share/doc/network-manager-1.12.2 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
<code class="literal">[main] plugins=keyfile</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -fg 86 netdev &&
/usr/sbin/usermod -a -G netdev <em class="replaceable"><code><username></code></em>

cat > /usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
<code class="literal">polkit.addRule(function(action, subject) { if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) { return polkit.Result.YES; } });</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable NetworkManager
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable NetworkManager-wait-online
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
