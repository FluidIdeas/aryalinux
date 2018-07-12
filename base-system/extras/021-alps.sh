#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="021-alps.sh"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

TARBALL="alps-master.tar.bz2"
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

rm -rf LICENSE
rm -rf README.md
cp -r * /
chmod a+x /var/lib/alps/*.sh
chmod a+x /usr/bin/alps

mkdir -pv /var/cache/alps/{sources,scripts,binaries}
tar xf alps-scripts*.tar.gz -C /var/cache/alps/scripts/

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
