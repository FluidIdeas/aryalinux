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
STEPNAME="026-lzo.sh"
TARBALL="lzo-2.10.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --enable-shared     \
            --disable-static    \
            --docdir=/usr/share/doc/lzo-2.10
make
make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
