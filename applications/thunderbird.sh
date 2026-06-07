#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cbindgen
#REQ:libarchive
#REQ:nodejs
#REQ:startup-notification
#REQ:dav1d
#REQ:nasm
#REQ:nss

cd $SOURCE_DIR
NAME=thunderbird
VERSION=140.8.0esr
URL=https://archive.mozilla.org/pub/thunderbird/releases/140.8.0esr/source/thunderbird-140.8.0esr.source.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.mozilla.org/pub/thunderbird/releases/140.8.0esr/source/thunderbird-140.8.0esr.source.tar.xz


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

patch -Np1 -i ../thunderbird-140.8.0esr-python_3.14_fixes-1.patch
for crate in {minimal-lexical,lmdb-rkv,cubeb-sys,wasi,glslopt,sfv}; do
  sed -e 's|,"[^"]*.gitmodules[^,]*[^,]||' \
      -e '$a\'                             \
      -i comm/third_party/rust/$crate/.cargo-checksum.json
done
GLSL_PTHREAD="comm/third_party/rust/glslopt/glsl-optimizer/include/c11/threads_posix.h"
OLDSHA=`sha256sum $GLSL_PTHREAD | awk '{ print $1 }'`
patch -Np1 -i ../thunderbird-140.8.0esr-glibc-2.43.patch
NEWSHA=`sha256sum $GLSL_PTHREAD | awk '{ print $1 }'`
sed "s/$OLDSHA/$NEWSHA/" \
  -i comm/third_party/rust/glslopt/.cargo-checksum.json
cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used.

# If you have installed wireless-tools comment out this line:
ac_add_options --disable-necko-wifi

# If you wish to use libproxy to determine proxy server information, you will
# need to install the libproxy package and then uncomment the option below:
#ac_add_options --enable-libproxy

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --enable-audio-backends=alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-av1
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# Thunderbird provides a copy of dav1d if it has not been installed. If you
# have not installed nasm and ffmpeg, uncomment the following line:
#ac_add_options --disable-av1

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=comm/mail

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-debug
ac_add_options --disable-debug-symbols
ac_add_options --disable-tests

# This enables SIMD optimization in the shipped encoding_rs crate.
ac_add_options --enable-rust-simd

ac_add_options --enable-strip
ac_add_options --enable-install-strip

# You cannot distribute the binary if you do this.
ac_add_options --enable-official-branding

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

# Using sandboxed wasm libraries has been moved to all builds instead
# of only mozilla automation builds. It requires extra llvm packages
# and was reported to seriously slow the build. Disable it.
ac_add_options --without-wasm-sandboxed-libraries
EOF
mountpoint -q /dev/shm || mount -t tmpfs devshm /dev/shm
export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=none
export MOZBUILD_STATE_PATH=$(pwd)/mozbuild
./mach build
unset MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE
unset MOZBUILD_STATE_PATH
MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=none ./mach install
mkdir -pv /usr/share/{applications,pixmaps}
cat > /usr/share/applications/thunderbird.desktop << "EOF"
[Desktop Entry]
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Network;Email;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF

ln -sfv /usr/lib/thunderbird/chrome/icons/default/default256.png \
        /usr/share/pixmaps/thunderbird.png

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd