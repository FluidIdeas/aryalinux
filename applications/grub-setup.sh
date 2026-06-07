#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=grub-setup
VERSION=0
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")


echo $USER > /tmp/currentuser

mkfs.vfat /dev/sdx1
fdisk /dev/sdx

Welcome to fdisk (util-linux 2.39.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): t
Partition number (1-9, default 9): 1
Partition type or alias (type L to list all): uefi
Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): w
The partition table has been altered.
Syncing disks.
        
          Still as the root user, create a
          mount point for the EFI partition on the USB flash drive and mount
          it:
        
        mount --mkdir -v -t vfat /dev/sdx1 -o codepage=437,iocharset=iso8859-1 /mnt/rescue
grub-install --target=x86_64-efi --removable \
             --efi-directory=/mnt/rescue --boot-directory=/mnt/rescue
umount /mnt/rescue
fdisk -l /dev/sda
mount --mkdir -v -t vfat /dev/sda1 -o codepage=437,iocharset=iso8859-1 /boot/efi
cat >> /etc/fstab << EOF
/dev/sda1 /boot/efi vfat codepage=437,iocharset=iso8859-1 0 1
EOF
grub-install --target=x86_64-efi --removable
mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
grub-install --bootloader-id=LFS --recheck
cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)

insmod efi_gop
insmod efi_uga
if loadfont /boot/grub/fonts/unicode.pf2; then
  terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 6.16.1-lfs-12.4" {
  linux   /boot/vmlinuz-6.16.1-lfs-12.4 root=/dev/sda2 ro
}

menuentry "Firmware Setup" {
  fwsetup
}
EOF
cat >> /boot/grub/grub.cfg << EOF
# Begin Windows addition

menuentry "Windows 11" {
  insmod fat
  insmod chain
  set root=(hd0,1)
  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd