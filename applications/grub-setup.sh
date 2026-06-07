#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR

NAME=grub-setup
SECTION="File Systems and Disk Management"

mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

if [ -f /etc/aryalinux/build-settings ]; then
	. /etc/aryalinux/build-settings
fi

if [ -z "$EFI_PART" ]; then
	read -e -p "EFI System Partition [/dev/sda1]: " EFI_PART
	EFI_PART=${EFI_PART:-/dev/sda1}
fi

BOOTLOADER_ID="${OS_NAME:-AryaLinux}"
BOOTLOADER_ID="${BOOTLOADER_ID// /}"

mkdir -pv /boot/efi
if ! mountpoint -q /boot/efi; then
	mount -v -t vfat "$EFI_PART" -o codepage=437,iocharset=iso8859-1 /boot/efi
fi

if ! grep -q '/boot/efi' /etc/fstab; then
	EFI_PART_UUID=$(blkid -s UUID -o value "$EFI_PART")
	cat >> /etc/fstab << EOF
UUID=$EFI_PART_UUID  /boot/efi  vfat  defaults  0  1
efivarfs  /sys/firmware/efi/efivars  efivarfs  defaults  0  1
EOF
fi

mountpoint /sys/firmware/efi/efivars || \
	mount -v -t efivarfs efivars /sys/firmware/efi/efivars

grub-install --bootloader-id="$BOOTLOADER_ID" --recheck
grub-install --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd
