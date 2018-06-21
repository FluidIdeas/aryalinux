7#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="089-systemd.sh"
TARBALL="systemd-238.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

ln -sf /tools/bin/true /usr/bin/xsltproc

ln -svf /tools/lib/pkgconfig/mount.pc /usr/lib/pkgconfig/
ln -svf /tools/lib/pkgconfig/blkid.pc /usr/lib/pkgconfig/
ln -svf /tools/lib/pkgconfig/uuid.pc /usr/lib/pkgconfig/
ln -svf /tools/bin/env /usr/bin/
ln -svf /tools/lib/libblkid.so.1 /usr/lib/
ln -svf /tools/lib/libmount.so.1 /usr/lib/

tar -xf ../systemd-man-pages-238.tar.xz
sed '171,$ d' -i src/resolve/meson.build
sed -i '527,565 d'                  src/basic/missing.h
sed -i '24 d'                       src/core/load-fragment.c
sed -i '53 a#include <sys/mount.h>' src/shared/bus-unit-util.c
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in
mkdir -p build
cd       build
LANG=en_US.UTF-8                   \
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
LANG=en_US.UTF-8 ninja
LANG=en_US.UTF-8 ninja install
rm -rfv /usr/lib/rpm
rm -f /usr/bin/xsltproc

rm -f /usr/lib/pkgconfig/mount.pc
rm -f /usr/lib/pkgconfig/blkid.pc
rm -f /usr/lib/pkgconfig/uuid.pc
rm -f /usr/bin/env

systemd-machine-id-setup
cat > /lib/systemd/systemd-user-sessions << "EOF"
#!/bin/bash
rm -f /run/nologin
EOF
chmod 755 /lib/systemd/systemd-user-sessions


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
