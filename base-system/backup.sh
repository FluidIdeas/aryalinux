#!/bin/bash

set -e
set +h

# Unmount everything except root, even the overlay so that we have a proper tarball.
# This is not needed as backup.sh is called immediately after strip-debug which takes care of umounting...

# ./umountal.sh

. ./build-properties

LABEL=$1
TOOLCHAIN_BACKUP=$2
sleep 5

LFS=/mnt/lfs

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd /

if [ ! -f $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz ]
then
	GZIP=-9 tar \
	--exclude="/mnt/lfs/sources" \
	--exclude="/mnt/lfs/tools" \
	--exclude="/mnt/lfs/root/.ccache" \
	--exclude="/mnt/lfs/home/aryalinux/.ccache" \
	--exclude="/mnt/lfs/var/cache/alps/binaries" \
	--exclude="/mnt/lfs/var/cache/alps/sources" \
	--exclude="/mnt/ls/opt/x-server/sources" \
	--exclude="/mnt/lfs/opt/x-server/var/cache/alps/sources/*" \
	--exclude="/mnt/ls/opt/desktop-environment/sources" \
	--exclude="/mnt/lfs/opt/desktop-environment/var/cache/alps/sources/*"  \
	-czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz $LFS
	if [ "$TOOLCHAIN_BACKUP" == "y" ] || [ "$TOOLCHAIN_BACKUP" == "Y" ] && [ ! -f $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz ] ; then
		XZ_OPT=-9 tar -cJvf $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz $LFS/tools
	fi
fi

popd
