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

cd squashfs-tools
sed 's@#XZ_SUPPORT@XZ_SUPPORT@g' -i Makefile
sed 's@COMP_DEFAULT = gzip@COMP_DEFAULT = xz@g' -i Makefile

export CFLAGS="-march=skylake -mtune=generic -O3"
export CXXFLAGS="-march=skylake -mtune=generic -O3"
export CPPFLAGS="-march=skylake -mtune=generic -O3"

make
sudo make INSTALL_DIR=/bin install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
