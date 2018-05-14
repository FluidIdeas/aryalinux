#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak SeaMonkey is a browser suite, thebr3ak Open Source sibling of Netscape.br3ak It includes the browser, composer, mail and news clients, and anbr3ak IRC client. It is the follow-on to the Mozilla browser suite.br3ak"
SECTION="xsoft"
VERSION=2.49.2
NAME="seamonkey"

#REQ:autoconf213
#REQ:gtk2
#REQ:gtk3
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:pulseaudio
#REC:sqlite
#OPT:alsa-lib
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:gst10-plugins-base
#OPT:openjdk
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

URL=https://archive.mozilla.org/pub/seamonkey/releases/2.49.2/source/seamonkey-2.49.2.source.tar.xz

if [ ! -z $URL ]
then
wget -nc https://archive.mozilla.org/pub/seamonkey/releases/2.49.2/source/seamonkey-2.49.2.source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.49.2.source.tar.xz

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

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"
# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus
# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa
# Comment out following option if you have gconf installed
ac_add_options --disable-gconf
# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu
# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=suite
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize="-O2"
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
# From firefox-40 (and the corresponding version of seamonkey),
# using system cairo caused seamonkey to crash
# frequently when it was doing background rendering in a tab.
# This appears to again work in seamonkey-2.49.2
ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
EOF


CFLAGS_HOLD=$CFLAGS           &&
CXXFLAGS_HOLD=$CXXFLAGS       &&
EXTRA_FLAGS=" -fno-delete-null-pointer-checks -fno-lifetime-dse -fno-schedule-insns2" &&
export CFLAGS+=$EXTRA_FLAGS   &&
export CXXFLAGS+=$EXTRA_FLAGS &&
unset EXTRA_FLAGS             &&
make -f client.mk



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make  -f client.mk install INSTALL_SDK= &&
chown -R 0:0 /usr/lib/seamonkey-2.49.2    &&
cp -v $(find -name seamonkey.1 | head -n1) /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export CFLAGS=$CFLAGS_HOLD     &&
export CXXFLAGS=$CXXFLAGS_HOLD &&
unset CFLAGS_HOLD CXXFLAGS_HOLD



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C obj* install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/{applications,pixmaps}              &&
cat > /usr/share/applications/seamonkey.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=SeaMonkey
Comment=The Mozilla Suite
Icon=seamonkey
Exec=seamonkey
Categories=Network;GTK;Application;Email;Browser;WebBrowser;News;
StartupNotify=true
Terminal=false
EOF
ln -sfv /usr/lib/seamonkey-2.49.2/chrome/icons/default/seamonkey.png \
        /usr/share/pixmaps

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
