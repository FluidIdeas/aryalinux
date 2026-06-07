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
STEPNAME="010-busybox.sh"
TARBALL="busybox-1.37.0.tar.bz2"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

make defconfig
sed 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' -i .config
sed 's/CONFIG_STATIC_LIBGCC=n/CONFIG_STATIC_LIBGCC=y/' -i .config
grep -q '^CONFIG_STATIC_LIBGCC=' .config || echo 'CONFIG_STATIC_LIBGCC=y' >> .config
sed 's/CONFIG_FEATURE_HAVE_RPC=y/# CONFIG_FEATURE_HAVE_RPC is not set/' -i .config
sed 's/CONFIG_FEATURE_MOUNT_NFS=y/# CONFIG_FEATURE_MOUNT_NFS is not set/' -i .config
sed 's/CONFIG_FEATURE_INETD_RPC=y/# CONFIG_FEATURE_INETD_RPC is not set/' -i .config
# Linux 6.8+ removed CBQ symbols from pkt_sched.h; tc fails to compile (busybox #15934)
sed 's/^CONFIG_TC=y$/# CONFIG_TC is not set/' -i .config
sed 's/^CONFIG_FEATURE_TC_INGRESS=y$/# CONFIG_FEATURE_TC_INGRESS is not set/' -i .config
make
cp -v busybox /bin

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
