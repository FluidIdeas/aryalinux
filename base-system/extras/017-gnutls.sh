#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="017-gnutls.sh"
TARBALL="gnutls-3.5.14.tar.xz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL" ./configure --prefix=/usr \
	--with-default-trust-store-pkcs11="pkcs11:" \
	--with-included-unistring &&
make
make install
make -C doc/reference install-data-local

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
