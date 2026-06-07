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
STEPNAME="008-efibootmgr.sh"
TARBALL="efibootmgr-18.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY
EFIDIR=$(echo "$OS_CODENAME" | tr '[:lower:]' '[:upper:]')
make EFIDIR=$EFIDIR EFI_LOADER=grubx64.efi
make install EFIDIR=$EFIDIR

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
