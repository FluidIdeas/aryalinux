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
STEPNAME="019-alps.sh"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd /sources

TARBALL="alps-new-$OS_VERSION.tar.gz"

mkdir -pv alps-extract
tar xf $TARBALL -C alps-extract
cp -r alps-extract/* /
chmod a+x /var/lib/alps/*.sh
chmod a+x /usr/bin/alps

rm -rf alps-extract

mkdir -pv /var/cache/alps/{sources,scripts,binaries}
tar xf alps-scripts-$OS_VERSION.tar.gz -C /var/cache/alps/scripts/
chmod a+rw /var/cache/alps/{sources,binaries}

echo "$STEPNAME" | tee -a $LOGFILE

fi
