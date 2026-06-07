#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="009-bootloader.sh"

if [ "$INSTALL_BOOTLOADER" == "n" ] || [ "$INSTALL_BOOTLOADER" == "N" ]; then
	exit
fi

if [ "$INSTALL_BOOTLOADER" == "y" ] || [ "$INSTALL_BOOTLOADER" == "Y" ]; then
  if ! /sources/bootloader-check.sh; then
    echo "Bootloader check failed; skipping $STEPNAME" >&2
    exit 1
  fi
fi

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

install_grub_bios() {
	grub-install "$DEV_NAME"
	grub-mkconfig -o /boot/grub/grub.cfg
}

install_grub_efi() {
	local efipart="$1"
	local efipart_uuid bootloader_id efi_target

	efipart_uuid=$(blkid -s UUID -o value "$efipart")
	# Short ID for the ESP directory and firmware menu (no spaces or slashes).
	bootloader_id="${OS_NAME:-AryaLinux}"
	bootloader_id="${bootloader_id// /}"

	case $(uname -m) in
		x86_64) efi_target=x86_64-efi ;;
		*)      efi_target=$(uname -m)-efi ;;
	esac

	mkdir -pv /boot/efi
	if ! mountpoint -q /boot/efi; then
		mount -vt vfat -o codepage=437,iocharset=iso8859-1 "$efipart" /boot/efi
	fi

	if [ -d /sys/firmware/efi/efivars ] && ! mountpoint -q /sys/firmware/efi/efivars; then
		mount -t efivarfs efivars /sys/firmware/efi/efivars
	fi

	if ! grep -q '/boot/efi' /etc/fstab; then
		cat >> /etc/fstab <<EOF
UUID=$efipart_uuid       /boot/efi    vfat     codepage=437,iocharset=iso8859-1  0     1
efivarfs       /sys/firmware/efi/efivars  efivarfs  defaults  0      1
EOF
	fi

	# grub-install registers the NVRAM entry; do not call efibootmgr with a
	# hard-coded /EFI/grub path — that does not match --bootloader-id output.
	grub-install --target="$efi_target" \
		--efi-directory=/boot/efi \
		--bootloader-id="$bootloader_id" \
		--recheck

	# Fallback path for firmware that only lists removable-media boot entries.
	grub-install --target="$efi_target" \
		--efi-directory=/boot/efi \
		--removable \
		--recheck

	grub-mkconfig -o /boot/grub/grub.cfg
}

if [ -d /sys/firmware/efi ]; then
	if [ -n "$EFI_PART" ]; then
		EFIPART="$EFI_PART"
	else
		EFIPART="${DEV_NAME}$(partx -s "$DEV_NAME" | tr -s ' ' | grep "EFI" | sed "s@^ *@@g" | cut "-d " -f1)"
	fi

	if [ -n "$EFIPART" ] && [ "$EFIPART" != "$DEV_NAME" ] && [ -b "$EFIPART" ]; then
		install_grub_efi "$EFIPART"
	else
		echo "No EFI System Partition found on $DEV_NAME; installing BIOS GRUB" >&2
		install_grub_bios
	fi
else
	install_grub_bios
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
