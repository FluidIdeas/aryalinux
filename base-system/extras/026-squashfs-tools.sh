#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="026-squashfs-tools.sh"
TARBALL="squashfs4.3.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

patch -Np1 -i ../squashfs-tools-4.3-sysmacros.patch
cd squashfs-tools
sed 's@#XZ_SUPPORT@XZ_SUPPORT@g' -i Makefile
sed 's@COMP_DEFAULT = gzip@COMP_DEFAULT = xz@g' -i Makefile

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

make
sudo make INSTALL_DIR=/bin install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
