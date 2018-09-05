#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="012-libtasn1.sh"
TARBALL="libtasn1-4.12.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" ./configure --prefix=/usr --disable-static &&
make
make install
make -C doc/reference install-data-local

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
