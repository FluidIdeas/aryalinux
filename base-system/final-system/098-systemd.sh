#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=098-systemd

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=systemd-241.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

ln -sf /tools/bin/true /usr/bin/xsltproc
for file in /tools/lib/lib{blkid,mount,uuid}.so*; do
    ln -sf $file /usr/lib/
done
tar -xf ../systemd-man-pages-241.tar.xz
sed '177,$ d' -i src/resolve/meson.build
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in
mkdir -p build
cd       build

PKG_CONFIG_PATH="/usr/lib/pkgconfig:/tools/lib/pkgconfig" \
LANG=$LOCALE                   \
meson --prefix=/usr                \
      --sysconfdir=/etc            \
      --localstatedir=/var         \
      -Dblkid=true                 \
      -Dbuildtype=release          \
      -Ddefault-dnssec=no          \
      -Dfirstboot=false            \
      -Dinstall-tests=false        \
      -Dkill-path=/bin/kill        \
      -Dkmod-path=/bin/kmod        \
      -Dldconfig=false             \
      -Dmount-path=/bin/mount      \
      -Drootprefix=                \
      -Drootlibdir=/lib            \
      -Dsplit-usr=true             \
      -Dsulogin-path=/sbin/sulogin \
      -Dsysusers=false             \
      -Dumount-path=/bin/umount    \
      -Db_lto=false                \
      ..
LANG=$LOCALE ninja
LANG=$LOCALE ninja install
rm -rfv /usr/lib/rpm
rm -f /usr/bin/xsltproc
systemd-machine-id-setup
rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf

fi

cleanup $DIRECTORY
log $NAME