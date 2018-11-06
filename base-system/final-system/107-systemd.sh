#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="107-systemd.sh"
TARBALL="systemd-239.tar.gz"

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

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

ln -sf /tools/bin/true /usr/bin/xsltproc
for file in /tools/lib/lib{blkid,mount,uuid}*; do
    ln -sf $file /usr/lib/
done
tar -xf ../systemd-man-pages-239.tar.xz
sed '166,$ d' -i src/resolve/meson.build
patch -Np1 -i ../systemd-239-glibc_statx_fix-1.patch
patch -Np1 -i ../systemd-239-meson-0.48.0_fixes-1.patch
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in
mkdir -p build
cd       build
PKG_CONFIG_PATH="/usr/lib/pkgconfig:/tools/lib/pkgconfig" \
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
