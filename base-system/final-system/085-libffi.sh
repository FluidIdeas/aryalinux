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
STEPNAME="085-libffi.sh"
TARBALL="libffi-3.2.1.tar.gz"

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

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in
./configure --prefix=/usr --disable-static 
make
make install


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
