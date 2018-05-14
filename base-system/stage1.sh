#!/bin/bash

set -e
set +h

clear

TIMEZONE=`tzselect`

rm -rf /tools
rm -rf /sources
rm -rf /mnt/lfs

cat >> build-properties << EOF
TIMEZONE=$TIMEZONE
EOF

clear

echo "LFS=/mnt/lfs" >> build-properties

. ./build-properties

export LFS=/mnt/lfs

# Checking root is valid block device
if [ ! -z "${ROOT_PART}" ] && [ -b "${ROOT_PART}" ]
then
	mkfs -F -v -t ext4 ${ROOT_PART}
else
	echo "${ROOT_PART} is not a valid block device. Aborting..."
	exit 1
fi
# End checking root is valid block device

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

# Checking swap is a valid block device
if [ ! -z "${SWAP_PART}" ] && [ -b "${SWAP_PART}" ]
then
	# Checking swap active
	if [ -z '`swapon -s | grep "${SWAP_PART} "`' ]
	then
		# Checking if swap needs to be formatted
		if [ "${FORMAT_SWAP}" == "y" ] || [ "${FORMAT_SWAP}" == "Y" ]
		then
			mkswap ${SWAP_PART}
		fi
		# End checking if swap needs to be formatted
		swapon ${SWAP_PART}
	else
		echo 'Swap partition exists and is active. Not formatting'
	fi
	# End checking if swap active
else
	echo "No valid swap partition specified. Continuing without swap partition..."
fi
# End checking id swap is a valid block device

# Checking if home is a valid block device
if [ ! -z "${HOME_PART}" ] && [ -b "${HOME_PART}" ] && [ "${HOME_PART}" != "${ROOT_PART}" ]
then
	# Checking if home needs to be formatted
	if [ "${FORMAT_HOME}" == "y" ] || [ "${FORMAT_HOME}" == "Y" ]
	then
		mkfs.ext4 -F -v "${HOME_PART}"
	fi
	# End checking if home needs to be formatted
	mkdir -pv $LFS/home
	mount ${HOME_PART} $LFS/home
else
	echo "No valid and different home partition specified. Continuing with home on root partition..."
fi
# End checking if home is a valid block device

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

ln -svf $LFS/sources /sources

cp -r ~/sources/* $LFS/sources
touch $LFS/sources/currentstage

mkdir -v $LFS/tools
ln -sv $LFS/tools /

mkdir -pv $LFS/var/cache/alps/sources

if [ -d ~/sources-apps ]
then
	cp -r ~/sources-apps/* $LFS/var/cache/alps/sources/
	chmod -R a+rw $LFS/var/cache/alps/sources
fi

if grep lfs /etc/passwd
then
	userdel -r lfs
fi

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

cp -r * /home/lfs/
cp -r * /sources/
chown -R lfs:lfs /home/lfs/*
chown -R lfs:lfs /sources/*

chown -R lfs:lfs /home/lfs
