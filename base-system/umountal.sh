#!/bin/bash

export LFS=/mnt/lfs

mountpoints="$LFS/dev/pts
$LFS/dev/shm
$LFS/dev
$LFS/sys
$LFS/proc
$LFS/run
$LFS/home"

echo "Unmounting virtual directories..."
for mountpoint in $mountpoints; do
	if mount | grep "$mountpoint" &> /dev/null; then
		umount -v "$mountpoint" &> /dev/null
	fi
done

echo "Unmounting overlay if present..."
if mount | grep "overlay on $LFS" &> /dev/null && [ "x$1" != "xkeepoverlay" ]; then
	umount -v $LFS
fi

echo "Unmounting root if mounted and requested"
if [ "x$1" == "xall" ]; then
	if mount | grep "$ROOT_PART on $LFS" &> /dev/null; then
		umount -v $LFS
	fi
fi