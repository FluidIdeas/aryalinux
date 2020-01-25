#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:autoconf213
#REQ:cbindgen
#REQ:llvm
#REQ:gtk3
#REQ:gtk2
#REQ:libnotify
#REQ:nodejs
#REQ:nss
#REQ:pulseaudio
#REQ:alsa-lib
#REQ:rust
#REQ:unzip
#REQ:yasm
#REQ:zip
#REQ:icu
#REQ:libevent
#REQ:libwebp
#REQ:sqlite


cd $SOURCE_DIR

wget -nc https://archive.mozilla.org/pub/firefox/releases/69.0.3/source/firefox-69.0.3.source.tar.xz


NAME=firefox
VERSION=69.0.3
URL=https://archive.mozilla.org/pub/firefox/releases/69.0.3/source/firefox-69.0.3.source.tar.xz
SECTION="Graphical Web Browsers"
DESCRIPTION="Firefox is a stand-alone browser based on the Mozilla codebase."

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

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.

# If you have installed dbus-glib, comment out this line:
#ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
#ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
#ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocaton API
# (needed for use with saved maps with Google Maps)
#ac_add_options --with-google-location-service-api-keyfile=$PWD/google-key

# Uncomment this line if you have installed startup-notification:
ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# If you have installed GConf, comment out this line
#ac_add_options --disable-gconf

# From firefox-61, the stylo CSS code can no-longer be disabled

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
# current firefox fails to build against libvpx-1.8.0
#ac_add_options --with-system-libvpx
# firefox-65 understands webp and ships with an included copy
ac_add_options --with-system-webp
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu

# The gold linker is no-longer the default
ac_add_options --enable-linker=gold

# The shipped libdavid (av1 decoder) is not built by default,
# at least on linux, but if nasm is not present libxul tries to
# link to one of libdavid's objects and fails.  It is thought
# libdavid will be enabled in firefox-67, at which point nasm
# might be required.
ac_add_options --disable-av1

# You cannot distribute the binary if you do this
#ac_add_options --enable-official-branding

# If you are going to apply the patch for system graphite
# and system harfbuzz, uncomment these lines:
#ac_add_options --with-system-graphite2
#ac_add_options --with-system-harfbuzz

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# With clang, unlike gcc-7 and later, the default level
# of optimization produces a working build.
ac_add_options --enable-optimize

# From firefox-61 system cairo is not supported

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

# From firefox-62 --with-pthreads is not recognized

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF
export SHELL=/bin/sh
sed -e 's/checkImpl/checkFFImpl/g' -i js/src/vm/JSContext*.h &&
export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib &&
export MOZBUILD_STATE_PATH=${PWD}/mozbuild &&
./mach build
if [ -f /sources/distro-build.sh ]; then
	DESTDIR=$BINARY_DIR/$NAME-$VERSION-$(uname-m) ./mach install
fi

sudo ./mach install                                                  &&

sudo mkdir -pv  /usr/lib/mozilla/plugins                             &&
sudo ln    -sfv ../../mozilla/plugins /usr/lib/firefox/browser/
unset CC CXX AR NM RANLIB MOZBUILD_STATE_PATH

sudo mkdir -pv /usr/share/applications &&
sudo mkdir -pv /usr/share/pixmaps &&

sudo tee /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

sudo ln -sfv /usr/lib/firefox/browser/chrome/icons/default/default128.png \
        /usr/share/pixmaps/firefox.png


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

