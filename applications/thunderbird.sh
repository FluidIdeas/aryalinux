#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Thunderbird is a stand-alonebr3ak mail/news client based on the Mozilla codebase. It uses the Gecko renderingbr3ak engine to enable it to display and compose HTML emails.br3ak"
SECTION="xsoft"
VERSION=60.3.0
NAME="thunderbird"

#REQ:autoconf213
#REQ:gtk3
#REQ:gtk2
#REQ:rust
#REQ:zip
#REQ:unzip
#REQ:yasm
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:cyrus-sasl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:llvm
#OPT:pulseaudio
#OPT:startup-notification
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

URL=https://archive.mozilla.org/pub/thunderbird/releases/60.3.0/source/thunderbird-60.3.0.source.tar.xz

if [ ! -z $URL ]
then
wget -nc https://archive.mozilla.org/pub/thunderbird/releases/60.3.0/source/thunderbird-60.3.0.source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/thunderbird/thunderbird-60.3.0.source.tar.xz

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
# If you have a multicore machine, the build may be faster if using parallel
# jobs. The build system automatically adds -jN to the "make" flags, where N
# is the number of CPU cores. The option below is therefore useless, unless
# you want to use a smaller number of jobs:
#mk_add_options MOZ_MAKE_FLAGS="-j1"
# If you have installed dbus-glib, comment out this line:
ac_add_options --disable-dbus
# If you have installed wireless-tools comment out this line:
ac_add_options --disable-necko-wifi
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
# Comment out following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio
# Comment out following option if you have gconf installed
ac_add_options --disable-gconf
# If you want to compile the Mozilla Calendar, uncomment this line:
#ac_add_options --enable-calendar
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
ac_add_options --enable-application=comm/mail
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-debug
ac_add_options --disable-tests
ac_add_options --enable-optimize=-O2
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-official-branding
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
EOF


./mach build



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./mach install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/{applications,pixmaps} &&
cat > /usr/share/applications/thunderbird.desktop << "EOF" &&
[Desktop Entry]
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Network;Email;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF
ln -sfv /usr/lib/thunderbird-60.3.0/chrome/icons/default/default256.png \
        /usr/share/pixmaps/thunderbird.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
