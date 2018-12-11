#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:autoconf213
#REQ:cbindgen
#REQ:llvm
#REQ:gtk3
#REQ:gtk2
#REQ:libnotify
#REQ:nss
#REQ:pulseaudio
#REQ:alsa-lib
#REQ:rust
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nodejs
#REC:sqlite
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:ffmpeg
#OPT:libwebp
#OPT:openjdk
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools
#OPT:liboauth
#OPT:graphite2
#OPT:harfbuzz

cd $SOURCE_DIR

wget -nc https://archive.mozilla.org/pub/firefox/releases/63.0.3/source/firefox-63.0.3.source.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/firefox-63.0.3-system_graphite2_harfbuzz-1.patch

URL=https://archive.mozilla.org/pub/firefox/releases/63.0.3/source/firefox-63.0.3.source.tar.xz

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

cat > mozconfig << "EOF"
<code class="literal"># If you have a multicore machine, all cores will be used by default. # You can change the number of non-rust jobs by setting a valid number # of cores in this option, but when rust crates are being compiled # jobs will be scheduled for all the available CPU cores. #mk_add_options MOZ_MAKE_FLAGS="-j1" # If you have installed dbus-glib, comment out this line: ac_add_options --disable-dbus # If you have installed dbus-glib, and you have installed (or will install) # wireless-tools, and you wish to use geolocation web services, comment out # this line ac_add_options --disable-necko-wifi # API Keys for geolocation APIs - necko-wifi (above) is required for MLS # Uncomment the following line if you wish to use Mozilla Location Service #ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key # Uncomment the following line if you wish to use Google's geolocaton API # (needed for use with saved maps with Google Maps) #ac_add_options --with-google-api-keyfile=$PWD/google-key # Uncomment this line if you have installed startup-notification: #ac_add_options --enable-startup-notification # Uncomment the following option if you have not installed PulseAudio #ac_add_options --disable-pulseaudio # and uncomment this if you installed alsa-lib instead of PulseAudio #ac_add_options --enable-alsa # If you have installed GConf, comment out this line ac_add_options --disable-gconf # Uncomment this if you have not installed nodejs, # but note that nodejs will be required in firefox-64 #ac_add_options --disable-nodejs # From firefox-61, the stylo CSS code can no-longer be disabled # Comment out following options if you have not installed # recommended dependencies: ac_add_options --enable-system-sqlite ac_add_options --with-system-libevent ac_add_options --with-system-libvpx ac_add_options --with-system-nspr ac_add_options --with-system-nss ac_add_options --with-system-icu # The gold linker is no-longer the default ac_add_options --enable-linker=gold # You cannot distribute the binary if you do this ac_add_options --enable-official-branding # If you are going to apply the patch for system graphite # and system harfbuzz, uncomment these lines: #ac_add_options --with-system-graphite2 #ac_add_options --with-system-harfbuzz # Stripping is now enabled by default. # Uncomment these lines if you need to run a debugger: #ac_add_options --disable-strip #ac_add_options --disable-install-strip # The BLFS editors recommend not changing anything below this line: ac_add_options --prefix=/usr ac_add_options --enable-application=browser ac_add_options --disable-crashreporter ac_add_options --disable-updater # enabling the tests will use a lot more space and significantly # increase the build time, for no obvious benefit. ac_add_options --disable-tests # Optimization for size is broken with gcc7 and later ac_add_options --enable-optimize="-O2" # From firefox-61 system cairo is not supported ac_add_options --enable-system-ffi ac_add_options --enable-system-pixman # From firefox-62 --with-pthreads is not recognized ac_add_options --with-system-bz2 ac_add_options --with-system-jpeg ac_add_options --with-system-png ac_add_options --with-system-zlib mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir</code>
EOF
patch -Np1 -i ../firefox-63.0.3-system_graphite2_harfbuzz-1.patch
echo "AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ" > google-key
echo "d2284a20-0505-4927-a809-7ffaf4d91e55" > mozilla-key
sed -e 's/checkImpl/checkFFImpl/g' -i js/src/vm/JSContext*.h &&
export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib &&
./mach build &&
unset CC CXX AR NM RANLIB

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
./mach install                                                  &&

mkdir -pv  /usr/lib/mozilla/plugins                             &&
ln    -sfv ../../mozilla/plugins /usr/lib/firefox/browser/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir -pv /usr/share/applications &&
mkdir -pv /usr/share/pixmaps &&

cat > /usr/share/applications/firefox.desktop << "EOF" &&
<code class="literal">[Desktop Entry] Encoding=UTF-8 Name=Firefox Web Browser Comment=Browse the World Wide Web GenericName=Web Browser Exec=firefox %u Terminal=false Type=Application Icon=firefox Categories=GNOME;GTK;Network;WebBrowser; MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https; StartupNotify=true</code>
EOF

ln -sfv /usr/lib/firefox/browser/chrome/icons/default/default128.png \
        /usr/share/pixmaps/firefox.png
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
