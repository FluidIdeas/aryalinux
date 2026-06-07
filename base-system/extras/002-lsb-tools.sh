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
STEPNAME="002-lsb-tools.sh"
TARBALL="LSB-Tools-0.9.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

python3 setup.py build
python3 setup.py install --optimize=1

cat > /etc/default/grub <<EOF
GRUB_DISTRIBUTOR="$OS_NAME $OS_VERSION $OS_CODENAME"
EOF

if [ "x$SWAP_PART" != "x" ]
then
cat >> /etc/default/grub <<EOF
GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/disk/by-uuid/$SWAP_PART_BY_UUID"
EOF
else
cat >> /etc/default/grub <<EOF
GRUB_CMDLINE_LINUX_DEFAULT=""
EOF
fi
cat >> /etc/default/grub <<EOF
GRUB_CMDLINE_LINUX="systemd.log_level=info systemd.log_target=console"
EOF


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
