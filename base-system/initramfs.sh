#!/bin/bash

set -e
set +h

. /sources/build-properties

INITRAMFS_PACKAGES=(
	initramfs-001-cpio
	initramfs-002-dash
	initramfs-003-dracut
)

for script in /sources/initramfs-tools/*.sh; do
	bash "$script"
done

for name in "${INITRAMFS_PACKAGES[@]}"; do
	if ! grep -q "$name" /sources/build-log; then
		exit 1
	fi
done

if ! grep -qx initramfs /sources/build-log; then
	echo initramfs >> /sources/build-log
fi
