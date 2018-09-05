#!/bin/bash

set -e
set +h

. /sources/build-properties

STEPNAME="kernel"
LOGFILE="/sources/build-log"

turnOn() {
	PROPERTY="$1"
	if grep "# $PROPERTY is not set" .config &> /dev/null
	then
		sed -i "s@# $PROPERTY is not set@$PROPERTY=y@g" .config
	else
		if ! grep "$PROPERTY=y" .config &> /dev/null
		then
			echo "$PROPERTY=y" >> .config
		fi
	fi
}

turnOff() {
	PROPERTY="$1"
	if grep "$PROPERTY=y" .config &> /dev/null
	then
		sed -i "s@$PROPERTY=y@# $PROPERTY is not set@g" .config
	else
		if ! grep "# $PROPERTY is not set" .config &> /dev/null
		then
			echo "# $PROPERTY is not set" >> .config
		fi
	fi
}

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd /sources

LINUX_TARBALL=$(grep "kernel.org/pub/linux/kernel" wget-list | rev | cut -d/ -f1 | rev)
LINUX_SRC_DIR=`tar -tf $LINUX_TARBALL | cut "-d/" -f1 | uniq`
tar xf $LINUX_TARBALL
cd $LINUX_SRC_DIR

tar xf ../aufs-4.17.tar.gz
for p in ../aufs*patch; do
	patch -Np1 -i $p
done

make mrproper

if [ `uname -m` != "x86_64" ]
then
	cp ../config-32 ./.config
else
	cp ../config-64 ./.config
fi

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

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
rm -rf $LINUX_SRC_DIR

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
