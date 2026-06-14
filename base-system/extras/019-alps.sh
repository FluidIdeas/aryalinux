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

install_alps_from_tree() {
    local tree="$1"
    install -d /etc/alps /var/lib/alps /usr/bin
    cp -a "$tree/usr/bin/alps" /usr/bin/alps
    cp -a "$tree/etc/alps/." /etc/alps/
    cp -a "$tree/var/lib/alps/." /var/lib/alps/
    chmod a+x /usr/bin/alps
    chmod -R a+rX /var/lib/alps/alps
}

if [ -f /sources/alps/usr/bin/alps ]; then
    install_alps_from_tree /sources/alps
else
    TARBALL="alps-new-$OS_VERSION.tar.gz"
    mkdir -pv alps-extract
    tar xf "$TARBALL" -C alps-extract
    cp -r alps-extract/* /
    chmod a+x /usr/bin/alps
    chmod -R a+rX /var/lib/alps/alps
    rm -rf alps-extract
fi

mkdir -pv /var/cache/alps/{sources,packages,staging,ports}
mkdir -pv /var/lib/alps/installed
# Build user runs alps (see apps/essentials.sh); cache and registry must be writable.
chmod a+rwX /var/cache/alps/{sources,packages,staging,ports}
chmod a+rwX /var/lib/alps/installed

echo "$STEPNAME" | tee -a $LOGFILE

fi
