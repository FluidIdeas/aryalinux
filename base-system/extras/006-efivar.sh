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
TARBALL="efivar-37.tar.bz2"

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

patch -Np1 -i ../b98ba8921010d03f46704a476c69861515deb1ca.patch &&
patch -Np1 -i ../c3c553db85ff10890209d0fe48fb4856ad68e4e0.patch

make libdir="/usr/lib/" bindir="/usr/bin/" \
	mandir="/usr/share/man/"     \
	includedir="/usr/include/" V=1 -j1

make -j1 V=1 DESTDIR="${pkgdir}/" libdir="/usr/lib/" \
	bindir="/usr/bin/" mandir="/usr/share/man"   \
	includedir="/usr/include/" install


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
