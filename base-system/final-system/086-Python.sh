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
STEPNAME="086-Python.sh"
TARBALL="Python-3.6.5.tar.xz"

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

CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" ./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make
make install
chmod -v 755 /usr/lib/libpython3.6m.so
chmod -v 755 /usr/lib/libpython3.so
install -v -dm755 /usr/share/doc/python-3.6.5/html 
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.6.5/html \
    -xvf ../python-3.6.5-docs-html.tar.bz2


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
