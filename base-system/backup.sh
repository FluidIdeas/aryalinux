#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LABEL=$1
TOOLCHAIN_BACKUP=$2
sleep 5

LFS=/mnt/lfs
mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd /

if [ ! -f $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz ]
then
	GZIP=-9 tar --exclude="/mnt/lfs/sources" --exclude="/mnt/lfs/tools" --exclude="/mnt/lfs/root/.ccache" --exclude="/mnt/lfs/home/aryalinux/.ccache" --exclude="/mnt/lfs/var/cache/alps/binaries" --exclude="/mnt/lfs/var/cache/alps/sources" -czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz $LFS
	if [ "$TOOLCHAIN_BACKUP" == "y" ] || [ "$TOOLCHAIN_BACKUP" == "Y" ] && [ ! -f $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz ] ; then
		XZ_OPT=-9 tar -cJvf $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz $LFS/tools
	fi
fi

popd
