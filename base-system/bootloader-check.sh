#!/bin/bash

set -e

if [ -f ./build-properties ]; then
	. ./build-properties
else
	. /sources/build-properties
fi

type=$(fdisk -l "$DEV_NAME" 2>/dev/null | grep "Disklabel type" | tr -s ' ' | rev | cut -d ' ' -f1 | rev)

# Bail out if booted in UEFI mode but the disk has an MBR partition table
if [ -d /sys/firmware/efi ] && [ "$type" = "msdos" ]; then
	echo "Cannot install bootloader. Please boot in legacy mode."
	exit 1
fi

# Bail out if booted in legacy mode but the disk has a GPT partition table
if [ ! -d /sys/firmware/efi ] && [ "$type" = "gpt" ]; then
	echo "Cannot install bootloader. Please boot in EFI mode."
	exit 1
fi

efipart=$(fdisk -l "$DEV_NAME" 2>/dev/null | grep "EFI System" | tr -s ' ' | cut -d ' ' -f1)

# Bail out if booted in UEFI mode with GPT but no EFI System Partition
if [ -d /sys/firmware/efi ] && [ "$type" = "gpt" ] && [ -z "$efipart" ]; then
	echo "Cannot install bootloader. No EFI Partition found."
	exit 1
fi
