#!/bin/bash

set -e
set +h

. /sources/build-properties

STEPNAME="kernel"
LOGFILE="/sources/build-log"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/kernel-config.sh"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
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

LINUX_VERSION=$(ls /lib/modules/)
cp -v arch/x86/boot/bzImage "/boot/vmlinuz-$LINUX_VERSION"
cp -v System.map "/boot/System.map-$LINUX_VERSION"
cp -v .config "/boot/config-$LINUX_VERSION"
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
ln -svf /usr/src/$LINUX_SRC_DIR /lib/modules/$(ls /lib/modules)/build
ln -svf /usr/src/$LINUX_SRC_DIR /lib/modules/$(ls /lib/modules)/source

FIRMWARE_TAR=`ls linux-firmware*`
FIRMWARE_DIR=`tar tf $FIRMWARE_TAR | cut -d/ -f1 | uniq`

tar xf $FIRMWARE_TAR
cd $FIRMWARE_DIR
make install
cd /sources
rm -rf $FIRMWARE_DIR

dracut -f /boot/initrd.img-$LINUX_VERSION `ls /lib/modules`

echo "$STEPNAME" | tee -a $LOGFILE

fi
