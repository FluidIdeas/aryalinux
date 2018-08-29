#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="016-p11kit.sh"
TARBALL="p11-kit-0.23.8.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

CFLAGS="-march=skylake -mtune=generic -O3" CXXFLAGS="-march=skylake -mtune=generic -O3" CPPFLAGS="-march=skylake -mtune=generic -O3" ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors &&
make
make install
if [ -e /usr/lib/libnssckbi.so ]; then
  readlink /usr/lib/libnssckbi.so ||
  rm -v /usr/lib/libnssckbi.so    &&
  ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
fi

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
