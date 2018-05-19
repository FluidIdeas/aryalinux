#!/bin/bash

./umountal.sh

RUNASUSER="$2"
COMMAND="$1"
PACKAGE="$3"

if [ -f /sources/build-properties ]
then
	. /sources/build-properties
elif [ -f ./build-properties ]
then
	. ./build-properties
	mount -v -t ext4 $ROOT_PART $LFS
fi

export LFS=/mnt/lfs
mkdir -pv $LFS

if [ "$SWAP_PART" != "" ] && [ ! -z '`swapon -s | grep "$SWAP_PART"`' ]
then
	swapon -v $SWAP_PART
fi

XSERVER="$LFS/opt/x-server"
DE="$LFS/opt/desktop-environment"

if [ -d "$XSERVER" ]; then
	if [ -d "$DE" ]; then
		if ! mount | grep "overlay on $LFS" &> /dev/null; then
			mount -t overlay -olowerdir=$XSERVER:$LFS,upperdir=$DE,workdir=$LFS/tmp overlay $LFS
		fi
	else
		if ! mount | grep "overlay on $LFS" &> /dev/null; then
			mount -t overlay -olowerdir=$LFS,upperdir=$XSERVER,workdir=$LFS/tmp overlay $LFS
		fi
	fi
fi

if ! mount | grep "$LFS/dev" &> /dev/null; then
	mount -v --bind /dev $LFS/dev
fi

if ! mount | grep "$LFS/dev/pts" &> /dev/null; then
	mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
fi

if ! mount | grep "$LFS/proc" &> /dev/null; then
	mount -vt proc proc $LFS/proc
fi

if ! mount | grep "$LFS/sys" &> /dev/null; then
	mount -vt sysfs sysfs $LFS/sys
fi

if ! mount | grep "$LFS/run" &> /dev/null; then
	mount -vt tmpfs tmpfs $LFS/run
fi

if ! mount | grep "$LFS/shm" &> /dev/null; then
	mount -vt tmpfs tmpfs $LFS/dev/shm
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login -e +h $*

