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
STEPNAME="052-gmp.sh"
TARBALL="gmp-6.1.2.tar.xz"

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

cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
make
make html
make install
make install-html


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
