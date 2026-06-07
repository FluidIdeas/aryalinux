#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cbindgen
#REQ:libarchive
#REQ:zip
#REQ:icu
#REQ:llvm
#REQ:nss

cd $SOURCE_DIR
NAME=seamonkey
VERSION=2.53.23
URL=https://archive.seamonkey-project.org/releases/2.53.23/source/seamonkey-2.53.23.source.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.seamonkey-project.org/releases/2.53.23/source/seamonkey-2.53.23.source.tar.xz


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

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used

# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi


# If you wish to use libproxy to determine proxy server information, you will
# need to install the libproxy package and then uncomment the option below:
#ac_add_options --enable-libproxy

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# Disabling debug symbols makes the build much smaller and a little
# faster. Comment this if you need to run a debugger.
ac_add_options --disable-debug-symbols

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB.  With recent Binutils releases the linker already
# supports a much safer and generic way for this.
ac_add_options --disable-elf-hack
ac_add_options --enable-linker=bfd
export LDFLAGS="$LDFLAGS -Wl,-z,pack-relative-relocs"

# Seamonkey has some additional features that are not turned on by default,
# such as an IRC client, calendar, and DOM Inspector. The DOM Inspector
# aids with designing web pages. Comment these options if you do not
# desire these features.
ac_add_options --enable-calendar
ac_add_options --enable-dominspector
ac_add_options --enable-irc

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=comm/suite

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

# The SIMD code relies on the unmaintained packed_simd crate which
# fails to build with Rustc >= 1.78.0.  We may re-enable it once
# Mozilla ports the code to use std::simd and std::simd is stabilized.
ac_add_options --disable-rust-simd

ac_add_options --enable-strip
ac_add_options --enable-install-strip

# You cannot distribute the binary if you do this.
ac_add_options --enable-official-branding

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

export CC=clang CXX=clang++
EOF
mountpoint -q /dev/shm || mount -t tmpfs devshm /dev/shm
(for i in {43..48}; do
   sed '/ZWJ/s/$/,CLASS_CHARACTER/' -i intl/lwbrk/LineBreaker.cpp || exit $?
done)
patch -Np1 -i ../seamonkey-2.53.23-cxx17-1.patch
patch -Np1 -i ../seamonkey-2.53.23-libvpx_security_fixes-1.patch
sed -i 's/icu-i18n/icu-uc &/' js/moz.configure
sed -e '/ExclusiveData(ExclusiveData
/,/^ *}/d' \
    -i js/src/threading/ExclusiveData.h
sed -e '1012 s/stderr=devnull/stderr=subprocess.DEVNULL/' \
    -e '1013 s/OSError/(OSError, subprocess.CalledProcessError)/' \
    -i third_party/python/distro/distro.py
export PATH_PY311=/opt/python3.11/bin:$PATH
export MOZBUILD_STATE_PATH=${PWD}/mozbuild
PATH=$PATH_PY311 AUTOCONF=true MACH_USE_SYSTEM_PYTHON=1 ./mach build
unset PATH_PY311 MOZBUILD_STATE_PATH
PATH=$PATH_PY311 MACH_USE_SYSTEM_PYTHON=1 ./mach install
chown -R 0:0 /usr/lib/seamonkey
cp -v $(find -name seamonkey.1 | head -n1) /usr/share/man/man1
mkdir -pv /usr/share/{applications,pixmaps}
cat > /usr/share/applications/seamonkey.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Seamonkey
Comment=The Mozilla Suite
Icon=seamonkey
Exec=seamonkey
Categories=Network;GTK;Application;Email;Browser;WebBrowser;News;
StartupNotify=true
Terminal=false
EOF

ln -sfv /usr/lib/seamonkey/chrome/icons/default/default128.png \
        /usr/share/pixmaps/seamonkey.png

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd