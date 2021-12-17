#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=098-systemd

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=systemd-249.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


patch -Np1 -i ../systemd-249-upstream_fixes-1.patch
sed -i -e 's/GROUP="render"/GROUP="video"/' \
        -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
sed -i 's/+ want_libfuzzer.*$/and want_libfuzzer/' meson.build
sed -i '/ARPHRD_CAN/a#define ARPHRD_MCTP        290' src/basic/linux/if_arp.h
mkdir -p build
cd       build

LANG=$LOCALE                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-249 \
      ..
LANG=$LOCALE ninja
LANG=$LOCALE ninja install
tar -xf ../../systemd-man-pages-249.tar.xz --strip-components=1 -C /usr/share/man
rm -rf /usr/lib/pam.d
systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-time-wait-sync.service

fi

cleanup $DIRECTORY
log $NAME