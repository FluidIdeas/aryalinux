#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:libnl
#OPT:dbus
#OPT:libxml2
#OPT:qt5

cd $SOURCE_DIR

wget -nc https://w1.fi/releases/wpa_supplicant-2.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wpa_supplicant-2.6-upstream_fixes-2.patch

NAME=wpa_supplicant
VERSION=2.6
URL=https://w1.fi/releases/wpa_supplicant-2.6.tar.gz

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

cat > wpa_supplicant/.config << "EOF"
<code class="literal">CONFIG_BACKEND=file CONFIG_CTRL_IFACE=y CONFIG_DEBUG_FILE=y CONFIG_DEBUG_SYSLOG=y CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON CONFIG_DRIVER_NL80211=y CONFIG_DRIVER_WEXT=y CONFIG_DRIVER_WIRED=y CONFIG_EAP_GTC=y CONFIG_EAP_LEAP=y CONFIG_EAP_MD5=y CONFIG_EAP_MSCHAPV2=y CONFIG_EAP_OTP=y CONFIG_EAP_PEAP=y CONFIG_EAP_TLS=y CONFIG_EAP_TTLS=y CONFIG_IEEE8021X_EAPOL=y CONFIG_IPV6=y CONFIG_LIBNL32=y CONFIG_PEERKEY=y CONFIG_PKCS12=y CONFIG_READLINE=y CONFIG_SMARTCARD=y CONFIG_WPS=y CFLAGS += -I/usr/include/libnl3</code>
EOF
cat >> wpa_supplicant/.config << "EOF"
<code class="literal">CONFIG_CTRL_IFACE_DBUS=y CONFIG_CTRL_IFACE_DBUS_NEW=y CONFIG_CTRL_IFACE_DBUS_INTRO=y</code>
EOF
patch -p1 -i ../wpa_supplicant-2.6-upstream_fixes-2.patch &&
cd wpa_supplicant                                         &&
make BINDIR=/sbin LIBDIR=/lib
pushd wpa_gui-qt4 &&
qmake wpa_gui.pro &&
make &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 wpa_{cli,passphrase,supplicant} /sbin/ &&
install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ &&
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 systemd/*.service /lib/systemd/system/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service \
                 /usr/share/dbus-1/system-services/ &&
install -v -d -m755 /etc/dbus-1/system.d &&
install -v -m644 dbus/dbus-wpa_supplicant.conf \
                 /etc/dbus-1/system.d/wpa_supplicant.conf
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable wpa_supplicant
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 wpa_gui-qt4/wpa_gui /usr/bin/ &&
install -v -m644 doc/docbook/wpa_gui.8 /usr/share/man/man8/ &&
install -v -m644 wpa_gui-qt4/wpa_gui.desktop /usr/share/applications/ &&
install -v -m644 wpa_gui-qt4/icons/wpa_gui.svg /usr/share/pixmaps/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
update-desktop-database
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -dm755 /etc/wpa_supplicant &&
wpa_passphrase <em class="replaceable"><code>SSID</code></em> <em class="replaceable"><code>SECRET_PASSWORD</code></em> > /etc/wpa_supplicant/wpa_supplicant-<em class="replaceable"><code>wifi0</code></em>.conf
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl start wpa_supplicant@<em class="replaceable"><code>wlan0</code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable wpa_supplicant@<em class="replaceable"><code>wlan0</code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
