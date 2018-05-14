#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak WPA Supplicant is a Wi-Fibr3ak Protected Access (WPA) client and IEEE 802.1X supplicant. Itbr3ak implements WPA key negotiation with a WPA Authenticator andbr3ak Extensible Authentication Protocol (EAP) authentication with anbr3ak Authentication Server. In addition, it controls the roaming andbr3ak IEEE 802.11 authentication/association of the wireless LAN driver.br3ak This is useful for connecting to a password protected wirelessbr3ak access point.br3ak"
SECTION="basicnet"
VERSION=2.6
NAME="wpa_supplicant"

#REC:libnl
#OPT:dbus
#OPT:libxml2
#OPT:qt5


cd $SOURCE_DIR

URL=https://w1.fi/releases/wpa_supplicant-2.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://w1.fi/releases/wpa_supplicant-2.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wpa_supplicant-2.6-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/wpa_supplicant/wpa_supplicant-2.6-upstream_fixes-1.patch

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

cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF


cat >> wpa_supplicant/.config << "EOF"
CONFIG_CTRL_IFACE_DBUS=y
CONFIG_CTRL_IFACE_DBUS_NEW=y
CONFIG_CTRL_IFACE_DBUS_INTRO=y
EOF


patch -p1 -i ../wpa_supplicant-2.6-upstream_fixes-1.patch &&
cd wpa_supplicant                                         &&
make BINDIR=/sbin LIBDIR=/lib



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 wpa_{cli,passphrase,supplicant} /sbin/ &&
install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ &&
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 systemd/*.service /lib/systemd/system/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service \
                 /usr/share/dbus-1/system-services/ &&
install -v -d -m755 /etc/dbus-1/system.d &&
install -v -m644 dbus/dbus-wpa_supplicant.conf \
                 /etc/dbus-1/system.d/wpa_supplicant.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable wpa_supplicant

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
