#!/bin/bash

# ./umountal.sh &> /dev/null

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

if [ "$HOME_PART" != "" ]
then
	mkdir -pv $LFS/home
	mount -v -t ext4 $HOME_PART $LFS/home
fi

if [ "$SWAP_PART" != "" ] && [ ! -z '`swapon -s | grep "$SWAP_PART"`' ]
then
	swapon -v $SWAP_PART
fi

if ! mount | grep "udev on $LFS/dev"; then
	mount -v --bind /dev $LFS/dev
fi

if ! mount | grep "devpts on $LFS/dev/pts"; then
	mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
fi
if ! mount | grep "proc on $LFS/proc"; then
	mount -vt proc proc $LFS/proc
fi
if ! mount | grep "sysfs on $LFS/sys"; then
	mount -vt sysfs sysfs $LFS/sys
fi
if ! mount | grep "tmpfs on $LFS/run"; then
	mount -vt tmpfs tmpfs $LFS/run
fi

if ! mount | grep "tmpfs on $LFS/dev/shm"; then
	mount -vt tmpfs tmpfs $LFS/dev/shm
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login -e +h $*

