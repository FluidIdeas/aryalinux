#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="010-busybox.sh"
TARBALL="busybox-1.20.2.tar.bz2"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

if [ "$BUILD_ARCH" != "none" ]; then
	export CFLAGS="$CFLAGS -march=$BUILD_ARCH"
	export CXXFLAGS="$CXXFLAGS -march=$BUILD_ARCH"
	export CPPFLAGS="$CPPFLAGS -march=$BUILD_ARCH"
fi
if [ "$BUILD_TUNE" != "none" ]; then
	export CFLAGS="$CFLAGS -mtune=$BUILD_TUNE"
	export CXXFLAGS="$CXXFLAGS -mtune=$BUILD_TUNE"
	export CPPFLAGS="$CPPFLAGS -mtune=$BUILD_TUNE"
fi
if [ "$BUILD_OPT_LEVEL" != "none" ]; then
	export CFLAGS="$CFLAGS -O$BUILD_OPT_LEVEL"
	export CXXFLAGS="$CXXFLAGS -O$BUILD_OPT_LEVEL"
	export CPPFLAGS="$CPPFLAGS -O$BUILD_OPT_LEVEL"
fi


patch -Np1 -i ../busybox-1.20.2-sys-resource.patch
make defconfig
sed 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' -i .config

sed 's/CONFIG_FEATURE_HAVE_RPC=y/# CONFIG_FEATURE_HAVE_RPC is not set/' \
        -i .config
sed 's/CONFIG_FEATURE_MOUNT_NFS=y/# CONFIG_FEATURE_MOUNT_NFS is not set/' \
        -i .config
sed 's/CONFIG_FEATURE_INETD_RPC=y/# CONFIG_FEATURE_INETD_RPC is not set/' \
        -i .config
make "-j`nproc`" || echo "..." >> $INSTALLED_LIST && make
cp -v busybox /bin

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
