#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:glib2
#REQ:alsa-lib
#REQ:libslirp

cd $SOURCE_DIR
NAME=qemu
VERSION=10.2.1
URL=https://download.qemu.org/qemu-10.2.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.qemu.org/qemu-10.2.1.tar.xz


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

echo $USER > /tmp/currentuser

if [ $(uname -m) = i686 ]; then
   QEMU_ARCH=i386-softmmu
else
   QEMU_ARCH=x86_64-softmmu
fi


mkdir -vp build
cd        build
../configure --prefix=/usr            \
             --sysconfdir=/etc        \
             --localstatedir=/var     \
             --target-list=$QEMU_ARCH \
             --audio-drv-list=alsa    \
             --disable-pa             \
             --enable-slirp           \
             --docdir=/usr/share/doc/qemu-10.2.1
unset QEMU_ARCH
make
VDISK_SIZE=50G
VDISK_FILENAME=vdisk.img
qemu-img create -f qcow2 $VDISK_FILENAME $VDISK_SIZE
qemu -enable-kvm                           \
     -drive file=$VDISK_FILENAME           \
     -cdrom Fedora-16-x86_64-Live-LXDE.iso \
     -boot d                               \
     -m 1G
qemu -enable-kvm                  \
     -smp 4                       \
     -cpu host                    \
     -m 1G                        \
     -drive file=$VDISK_FILENAME  \
     -cdrom grub-img.iso          \
     -boot order=c,once=d,menu=on \
     -net nic,netdev=net0         \
     -netdev user,id=net0         \
     -device ac97                 \
     -vga std                     \
     -serial mon:stdio            \
     -name "fedora-16"
usermod -a -G kvm <username>
chgrp kvm  /usr/libexec/qemu-bridge-helper
chmod 4750 /usr/libexec/qemu-bridge-helper
ln -sv qemu-system-`uname -m` /usr/bin/qemu
sysctl -w net.ipv4.ip_forward=1
cat >> /etc/sysctl.d/60-net-forward.conf << EOF
net.ipv4.ip_forward=1
EOF
echo allow br0 > /etc/qemu/bridge.conf


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -vdm 755 /etc/qemu
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd