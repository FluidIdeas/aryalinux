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
STEPNAME="006-efivar.sh"
TARBALL="efivar-master.tar.xz"

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
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
