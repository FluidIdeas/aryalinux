#!/bin/bash

set -e
set +h

. /sources/build-properties

STEPNAME="kernel"
LOGFILE="/sources/build-log"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/kernel-config.sh"

if ! grep -qx "$STEPNAME" $LOGFILE &> /dev/null
then

cd /sources

LINUX_TARBALL=$(grep "kernel.org/pub/linux/kernel" wget-list | rev | cut -d/ -f1 | rev)
LINUX_SRC_DIR=`tar -tf $LINUX_TARBALL | cut "-d/" -f1 | uniq`
tar xf $LINUX_TARBALL
cd $LINUX_SRC_DIR

make mrproper
kernel_configure_from_host
kernel_apply_lfs_requirements
kernel_apply_aryalinux_requirements

make "-j`nproc`"
make modules_install

LINUX_VERSION=$(ls /lib/modules/ | head -1)
cp -v arch/x86/boot/bzImage "/boot/vmlinuz-$LINUX_VERSION"
cp -v System.map "/boot/System.map-$LINUX_VERSION"
cp -v .config "/boot/config-$LINUX_VERSION"

echo "$STEPNAME" | tee -a $LOGFILE

install -d "/usr/share/doc/linux-$LINUX_VERSION"
cp -r Documentation/* "/usr/share/doc/linux-$LINUX_VERSION"

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

cd /sources
mv $LINUX_SRC_DIR /usr/src/
ln -svf /usr/src/$LINUX_SRC_DIR "/lib/modules/$LINUX_VERSION/build"
ln -svf /usr/src/$LINUX_SRC_DIR "/lib/modules/$LINUX_VERSION/source"

FIRMWARE_TAR=`ls linux-firmware*`
FIRMWARE_DIR=`tar tf $FIRMWARE_TAR | cut -d/ -f1 | uniq`

tar xf $FIRMWARE_TAR
cd $FIRMWARE_DIR
make install
cd /sources
rm -rf $FIRMWARE_DIR

# LFS builds systemd with -D sysusers=false; use a non-systemd initramfs.
DRACUT_OMIT="systemd dracut-systemd systemd-initrd systemd-udevd systemd-battery-check"
dracut -f --omit "$DRACUT_OMIT" "/boot/initrd.img-$LINUX_VERSION" "$LINUX_VERSION"

fi
