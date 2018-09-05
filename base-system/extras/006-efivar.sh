#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="006-efivar.sh"
TARBALL="efivar-36.tar.bz2"

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

make libdir="/usr/lib/" bindir="/usr/bin/" \
	mandir="/usr/share/man/"     \
	includedir="/usr/include/" V=1 -j1
pushd src/test
make
popd
make -j1 V=1 DESTDIR="${pkgdir}/" libdir="/usr/lib/" \
	bindir="/usr/bin/" mandir="/usr/share/man"   \
	includedir="/usr/include/" install
install -v -D -m0755 src/test/tester /usr/bin/efivar-tester

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
