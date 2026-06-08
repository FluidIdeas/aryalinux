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
chmod a+x /usr/bin/alps
chmod -R a+rX /var/lib/alps/alps

rm -rf alps-extract

mkdir -pv /var/cache/alps/{sources,packages,staging,ports}
mkdir -pv /var/lib/alps/installed
chmod a+rw /var/cache/alps/{sources,packages,staging}

echo "$STEPNAME" | tee -a $LOGFILE

fi
