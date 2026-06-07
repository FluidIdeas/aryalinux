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
STEPNAME="029-unzip.sh"
TARBALL="unzip60.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../patches/unzip-6.0-consolidated_fixes-1.patch
sed -i '/struct tm \*gmtime(), \*localtime();/d' unix/unxcfg.h
sed -i 's/CloseError(G\.outfile, G\.filename)/CloseError(__G)/g' unix/unix.c
sed -i '/^CF =/s/$/ -std=gnu17/' unix/Makefile
make -f unix/Makefile flags
# configure sets both NO_DIR and HAVE_DIRENT_H; the fake dirent stubs then
# conflict with the real <dirent.h> declarations on modern Linux/GCC.
sed -i 's/-DNO_DIR //g; s/ -DNO_DIR//g' flags
eval make -f unix/Makefile unzips ACONF_DEP=flags $(cat flags)
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
