#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=firmware
VERSION=""
URL=""

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

head -n7 /proc/cpuinfo
mkdir -pv /lib/firmware/intel-ucode
cp -v intel-ucode/<XX-YY-ZZ> /lib/firmware/intel-ucode
echo 1 > /sys/devices/system/cpu/microcode/reload
dmesg | grep -e 'microcode' -e 'Linux version' -e 'Command line'
mkdir -pv /lib/firmware/amd-ucode
cp -v microcode_amd* /lib/firmware/amd-ucode
echo 1 > /sys/devices/system/cpu/microcode/reload
dmesg | grep -e 'microcode' -e 'Linux version' -e 'Command line'
mkdir -p initrd/kernel/x86/microcode
cd initrd
cp -v /lib/firmware/amd-ucode/<MYCONTAINER> kernel/x86/microcode/AuthenticAMD.bin
cp -v /lib/firmware/intel-ucode/<XX-YY-ZZ> kernel/x86/microcode/GenuineIntel.bin
find . | cpio -o -H newc > /boot/microcode.img
initrd /microcode.img
initrd /boot/microcode.img
dmesg | grep -e 'microcode' -e 'Linux version' -e 'Command line'
mkdir -pv /lib/firmware/radeon
cp -v <YOUR_BLOBS> /lib/firmware/radeon
wget https://raw.github.com/imirkin/re-vp2/master/extract_firmware.py
wget http://us.download.nvidia.com/XFree86/Linux-x86/325.15/NVIDIA-Linux-x86-325.15.run
sh NVIDIA-Linux-x86-325.15.run --extract-only
python extract_firmware.py 
mkdir -p /lib/firmware/nouveau
cp -d nv* vuc-* /lib/firmware/nouveau/

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
