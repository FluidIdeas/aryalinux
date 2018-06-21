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

cp -v alps /usr/bin/
cp -v makepkg.sh /usr/bin
mkdir -pv /etc/alps
cp -v alps.conf /etc/alps/
mkdir -pv /var/cache/alps/scripts
mkdir -pv /var/cache/alps/sources
mkdir -pv /var/cache/alps/logs
mkdir -pv /var/cache/alps/binaries
chmod -R a+rw /var/cache/alps/binaries
chmod -R a+rw /var/cache/alps/sources
chmod -R a+rw /var/cache/alps/logs
mkdir -pv /var/lib/alps
cp -v functions /var/lib/alps/
cp -v selfupdate.sh /var/lib/alps/
cp -v updatescripts.sh /var/lib/alps/
cp -v *py /var/lib/alps
tar xf alps-scripts*.tar.gz -C /var/cache/alps/scripts/
chmod a+x /usr/bin/alps
chmod a+x /usr/bin/makepkg.sh
touch /etc/alps/installed-list
touch /etc/alps/versions

echo "$STEPNAME" | tee -a $LOGFILE

fi
