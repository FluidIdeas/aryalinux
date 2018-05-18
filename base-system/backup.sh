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
	--exclude="$LFS/sources" \
	--exclude="$LFS/tools" \
	--exclude="$LFS/root/.ccache" \
	--exclude="$LFS/home/$USERNAME/.ccache" \
	--exclude="$LFS/var/cache/alps/binaries" \
	--exclude="$LFS/var/cache/alps/sources" \
	--exclude="$LFS/opt/x-server/sources" \
	--exclude="$LFS/opt/x-server/home/$USERNAME/.ccache" \
	--exclude="$LFS/opt/x-server/var/cache/alps/sources/*" \
	--exclude="$LFS/opt/x-server/var/cache/alps/binaries/*" \
	--exclude="$LFS/opt/desktop-environment/sources" \
	--exclude="$LFS/opt/desktop-environment/home/$USERNAME/.ccache" \
	--exclude="$LFS/opt/desktop-environment/var/cache/alps/sources/*"  \
	--exclude="$LFS/opt/desktop-environment/var/cache/alps/binaries/*"  \
	-czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-$(uname -m).tar.gz $LFS
	if [ "$TOOLCHAIN_BACKUP" == "y" ] || [ "$TOOLCHAIN_BACKUP" == "Y" ] && [ ! -f $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz ] ; then
		XZ_OPT=-9 tar -cJvf $LFS/sources/toolchain-$OS_VERSION-$(uname -m).tar.xz $LFS/tools
	fi
fi

popd
