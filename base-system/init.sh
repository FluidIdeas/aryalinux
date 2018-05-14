#!/bin/busybox sh
#
# This file is a modified version of:
#
# Initramfs boot script 1.3.1 (2012-02-09)
# Copyright (c) 2010-2012   Marcel van den Boer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# FS layout at the start of this script:
# - /boot/id_label
# - /bin/busybox
# - /dev/console (created by kernel)
# - /init (this file)

set -e

ARCH="<ARCH>"

###########################################
copyBindMount() { # COPY/BIND LIVECD MODE #
###########################################

# This function bind-mounts directories which are designed to be capable of
# read-only access and copies the remaining directories to a tmpfs.
#
# The downside of this method is that the resulting root filesystem is not
# fully writable. So, for example, installation of new programs will not be
# possible.
#
# However, this function can be used without any modification to the kernel and
# is therefore perfect for use as a fallback if other options are not available.

# Mount a tmpfs where the new rootfs will be.
mount -t tmpfs tmpfs ${ROOT} # Allows remounting root in the bootscripts

# Bind mount read-only filesystems, copy the rest
cd /mnt/system
for dir in $(ls -1); do
    case ${dir} in
        lost+found)
            ;;
        bin | boot | lib | opt | sbin | usr)
            mkdir ${ROOT}/${dir}
            mount --bind ${dir} ${ROOT}/${dir}
            ;;
        *)
            cp -R ${dir} ${ROOT}
            ;;
    esac
done
cd /

##############################################
}; unionMount() { # UNIONFS/AUFS LIVECD MODE #
##############################################

# A union mount takes one or more directories and combines them transparantly
# in a third. This function creates a writable directory in memory (tmpfs) and
# uses it to overlay the read-only system image, resulting in a fully writable
# root file system.
#
# The only downside to this method is that it requires a union type filesystem
# in the kernel, which can only be accomplished by patching the kernel as there
# is no such feature in a vanilla kernel.

mkdir -p /mnt/tmpdir
mount -t tmpfs -o rw tmpfs /mnt/tmpdir
mkdir -p /mnt/tmpdir/writable
mkdir -p /mnt/tmpdir/workdir

mount -t overlay overlay -oupperdir=/mnt/tmpdir/writable,lowerdir=/mnt/system,workdir=/mnt/tmpdir/workdir ${ROOT} || \
{
    # If UnionFS fails, fall back to copy/bind mounting
    copyBindMount
}

######################
} # END OF FUNCTIONS #
######################

# Make required applets easier to access
for applet in cat chmod cp cut grep ls mkdir mknod mount umount switch_root \
    rm mv vi cpio tar mke2fs sync fdisk dd sleep; do
    /bin/busybox ln /bin/busybox /bin/${applet}
done

busybox clear
echo "Loading AryaLinux. Please wait..."
sleep 3

# Clear the screen
#clear # Don't! This will clear the Linux boot logo when using a framebuffer.
       # If you want to clear the screen on boot add the "clear" command to
       # '/usr/share/live/sec_init.sh' in the system image.

# Create device nodes required to run this script
# Note: /dev/console will already be available in the ramfs
# mknod /dev/null c  1  3

mknod /dev/scd0 b 11  0  # +--------
mknod /dev/scd1 b 11  1  # |
mknod /dev/scd2 b 11  2  # |
mknod /dev/scd3 b 11  3  # |
                         # |
mknod /dev/hdc  b 22  0  # |
                         # |
mknod /dev/sda  b  8  0  # |
mknod /dev/sda1 b  8  1  # |
mknod /dev/sda2 b  8  2  # |
mknod /dev/sda3 b  8  3  # |
mknod /dev/sda4 b  8  4  # |
                         # |
mknod /dev/sdb  b  8 16  # |    <----
mknod /dev/sdb1 b  8 17  # |        Devices which could be or contain the
mknod /dev/sdb2 b  8 18  # |        boot medium...
mknod /dev/sdb3 b  8 19  # |
mknod /dev/sdb4 b  8 20  # |
                         # |
mknod /dev/sdc  b  8 32  # |
mknod /dev/sdc1 b  8 33  # |
mknod /dev/sdc2 b  8 34  # |
mknod /dev/sdc3 b  8 35  # |
mknod /dev/sdc4 b  8 36  # |
                         # |
mknod /dev/sdd  b  8 48  # |
mknod /dev/sdd1 b  8 49  # |
mknod /dev/sdd2 b  8 50  # |
mknod /dev/sdd3 b  8 51  # |
mknod /dev/sdd4 b  8 52  # +--------

# Create mount points for filesystems
mkdir -p /mnt/medium
mkdir -p /mnt/system
mkdir -p /mnt/rootfs

# Mount the /proc filesystem (enables filesystem detection for 'mount')
mkdir /proc
mount -t proc proc /proc

# Invoke busybox if requested via the kernel command line.
if [ `grep -c "busybox" /proc/cmdline` -ne "0" ]; then 
    echo "Busybox requested"; 
    busybox sh
fi

# Search for, and mount the boot medium
LABEL="$(cat /boot/id_label)"
for device in $(ls /dev); do
    [ "${device}" == "console" ] && continue
    [ "${device}" == "null"    ] && continue

    mount -o ro /dev/${device} /mnt/medium 2> /dev/null && \
    if [ "$(cat /mnt/medium/isolinux/id_label)" != "${LABEL}" ]; then
        umount /mnt/medium
    else
        DEVICE="${device}"
        break
    fi
	busybox clear
	echo "Loading AryaLinux. Please wait..."
done

if [ "${DEVICE}" == "" ]; then
    echo "FATAL: Boot medium not found."
    /bin/busybox sh
fi

# Mount the system image
mount -t squashfs -o ro,loop /mnt/medium/aryalinux/root.sfs /mnt/system || {
    echo "FATAL: Boot medium found, but system image is missing."
    /bin/busybox sh
}

if [ -d /mnt/system/opt/x-server ]; then
	echo "x-server found.."
	if [ -d /mnt/system/opt/desktop-environment ]; then
		echo "desktop-environment found.."
		mount -t overlay -olowerdir=/mnt/system/opt/desktop-environment:/mnt/system/opt/x-server:/mnt/system,workdir=/mnt/system/tmp overlay /mnt/system || {
			echo "Could not mount desktop-environment and x-server"
			/bin/busybox sh
		}
	else
		mount -t overlay -olowerdir=/mnt/system/opt/x-server:/mnt/system,workdir=/mnt/system/tmp overlay /mnt/system || {
			echo "Could not mount x-server"
			/bin/busybox sh
		}
	fi
fi

busybox clear
echo "Loading AryaLinux. Please wait..."

# Define where the new root filesystem will be
ROOT="/mnt/rootfs" # Also needed for /usr/share/live/sec_init.sh

# Run in bootable cd mode if requested via the kernel command line.
if [ `grep -c "bootcd" /proc/cmdline` -ne "0" ]; then 
    echo "Bootcd mode (bind mount) requested"; 
    copyBindMount
else
    # Select LiveCD mode
    unionMount # Might fall back to copyBindMount
fi

# Tell LFS to skip fsck during startup:
> $ROOT/fastboot

# Get rid of / manipulations in mountfs script:
# grep -v ' \/ ' $ROOT/etc/rc.d/init.d/mountfs > $ROOT/tmp/mountfs
# rm -f $ROOT/etc/rc.d/init.d/mountfs
# mv $ROOT/tmp/mountfs $ROOT/etc/rc.d/init.d/mountfs
# chmod +x $ROOT/etc/rc.d/init.d/mountfs

# Move current mounts to directories accessible in the new root
cd /mnt
for dir in $(ls -1); do
    if [ "${dir}" != "rootfs" ]; then
        mkdir -p ${ROOT}/mnt/.boot/${dir}
        mount --move /mnt/${dir} ${ROOT}/mnt/.boot/${dir}
    fi
done
cd /

# Run secondary initialization (if the system provides it)
if [ -x ${ROOT}/usr/share/live/sec_init.sh ]; then
    . ${ROOT}/usr/share/live/sec_init.sh
fi

# Clean up
umount /proc
busybox clear
echo "Loading AryaLinux. Please wait..."
# Switch to the new root and launch INIT!
exec switch_root -c /dev/console ${ROOT} /sbin/init
