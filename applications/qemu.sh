#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:glib2
#REQ:python2
#REC:alsa-lib
#REC:sdl2
#OPT:alsa
#OPT:pulseaudio
#OPT:bluez
#OPT:curl
#OPT:cyrus-sasl
#OPT:gnutls
#OPT:gtk2
#OPT:gtk3
#OPT:libusb
#OPT:libgcrypt
#OPT:libssh2
#OPT:lzo
#OPT:nettle
#OPT:mesa
#OPT:sdl
#OPT:vte
#OPT:vte2

cd $SOURCE_DIR

wget -nc http://download.qemu-project.org/qemu-3.1.0.tar.xz

NAME=qemu
VERSION=3.1.0
URL=http://download.qemu-project.org/qemu-3.1.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

egrep '^flags.*(vmx|svm)' /proc/cpuinfo

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
usermod -a -G kvm <em class="replaceable"><code><username></code></em>
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ $(uname -m) = i686 ]; then
QEMU_ARCH=i386-softmmu
else
QEMU_ARCH=x86_64-softmmu
fi


mkdir -vp build &&
cd build &&

../configure --prefix=/usr \
--sysconfdir=/etc \
--target-list=$QEMU_ARCH \
--audio-drv-list=alsa \
--with-sdlabi=2.0 \
--docdir=/usr/share/doc/qemu-3.1.0 &&

unset QEMU_ARCH &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /lib/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660"
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chgrp kvm /usr/libexec/qemu-bridge-helper &&
chmod 4750 /usr/libexec/qemu-bridge-helper
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -sv qemu-system-`uname -m` /usr/bin/qemu
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

VDISK_SIZE=<em class="replaceable"><code>50G</code></em>
VDISK_FILENAME=<em class="replaceable"><code>vdisk.img</code></em>
qemu-img create -f qcow2 $VDISK_FILENAME $VDISK_SIZE
qemu -enable-kvm \
-drive file=$VDISK_FILENAME \
-cdrom Fedora-16-x86_64-Live-LXDE.iso \
-boot d \
-m <em class="replaceable"><code>1G</code></em>
qemu -enable-kvm \
-smp 4 \
-cpu host \
-m 1G \
-drive file=$VDISK_FILENAME \
-cdrom grub-img.iso \
-boot order=c,once=d,menu=on \
-net nic,netdev=net0 \
-netdev user,id=net0 \
-soundhw ac97 \
-vga std \
-serial mon:stdio \
-name "fedora-16"

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /usr/share/X11/xorg.conf.d/20-vmware.conf << "EOF"
Section "Monitor"
Identifier "Monitor0"
# cvt 1600 900
# 1600x900 59.95 Hz (CVT 1.44M9) hsync: 55.99 kHz; pclk: 118.25 MHz
Modeline "1600x900" 118.25 1600 1696 1856 2112 900 903 908 934 -hsync +vsync
Option "PreferredMode" "1600x900"
HorizSync 1-200
VertRefresh 1-200
EndSection

Section "Device"
Identifier "VMware SVGA II Adapter"
Option "Monitor" "default"
Driver "vmware"
EndSection

Section "Screen"
Identifier "Default Screen"
Device "VMware SVGA II Adapter"
Monitor "Monitor0"

SubSection "Display"
Depth 24
Modes "1600x900" "1440x900" "1366x768" "1280x720" "800x480"
EndSubSection

EndSection
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sysctl -w net.ipv4.ip_forward=1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/sysctl.d/60-net-forward.conf << EOF
net.ipv4.ip_forward=1
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm 755 /etc/qemu &&
echo allow br0 > /etc/qemu/bridge.conf
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
