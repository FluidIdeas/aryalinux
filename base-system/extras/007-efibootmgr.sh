#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="007-efibootmgr.sh"
TARBALL="efibootmgr-16.tar.bz2"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

export CFLAGS="-march=skylake -mtune=generic -O3"
export CXXFLAGS="-march=skylake -mtune=generic -O3"
export CPPFLAGS="-march=skylake -mtune=generic -O3"

patch -Np1 -i ../efibootmgr-16-efidir.patch
make
install -v -D -m0755 src/efibootmgr /usr/sbin/efibootmgr
install -v -D -m0644 src/efibootmgr.8 \
	/usr/share/man/man8/efibootmgr.8

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
