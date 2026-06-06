#!/bin/bash

set -e
set +h

SOURCE_DIR="/sources"

. /sources/build-properties

if ! grep "config-files" /sources/build-log &> /dev/null
then

# LFS 9.2.3 - hostname
echo "$HOST_NAME" > /etc/hostname

# LFS 9.2.4 - /etc/hosts (DHCP / systemd-resolved setup)
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost
::1       ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

# LFS 9.2.1 - systemd-networkd (DHCP on common interface name patterns)
mkdir -pv /etc/systemd/network

cat > /etc/systemd/network/10-ethernet-dhcp.network << "EOF"
[Match]
Name=en* eth*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

cat > /etc/systemd/network/20-wireless-dhcp.network << "EOF"
[Match]
Name=wl*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

# LFS 9.2.2.1 - systemd-resolved (static DNS fallback for installs without DHCP DNS)
mkdir -pv /etc/systemd/resolved.conf.d

cat > /etc/systemd/resolved.conf.d/aryalinux.conf << EOF
[Resolve]
DNS=8.8.8.8 8.8.4.4
Domains=$DOMAIN_NAME
EOF

# LFS 9.2.2 - temporary resolv.conf for the chroot environment only.
# Removed below so systemd-resolved can manage /etc/resolv.conf on first boot.
cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf

domain $DOMAIN_NAME

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

# LFS 9.5 - hardware clock assumed local time during automated install
cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

# LFS 9.7 - locale
cat > /etc/locale.conf << EOF
LANG=$LOCALE
EOF

# LFS 9.8 - inputrc
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

# LFS 9.6 - console keymap and font for systemd-vconsole-setup
cat > /etc/vconsole.conf << EOF
KEYMAP=$KEYBOARD
FONT=Lat2-Terminus16
EOF

# LFS 9.9 - shells
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

# AryaLinux - partition layout from build-properties (LFS chapter 10 / fstab)
if [ "x$ROOT_PART" != "x" ]; then
ROOT_PART_BY_UUID=$(blkid $ROOT_PART | cut -d\" -f2)
fi

if [ "x$SWAP_PART" != "x" ]; then
SWAP_PART_BY_UUID=$(blkid $SWAP_PART | cut -d\" -f2)
fi

if [ "x$HOME_PART" != "x" ]; then
HOME_PART_BY_UUID=$(blkid $HOME_PART | cut -d\" -f2)
fi

cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

UUID=$ROOT_PART_BY_UUID     /            ext4     defaults            1     1
EOF

if [ "x$SWAP_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$SWAP_PART_BY_UUID     swap         swap     pri=1               0     0
EOF
fi

if [ "x$HOME_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$HOME_PART_BY_UUID     /home        ext4     defaults            1     1
EOF
fi

cat >> /etc/fstab <<EOF

# End /etc/fstab
EOF

mkdir -pv /etc/aryalinux
grep -E '^(DEV_NAME|EFI_PART|ROOT_PART|SWAP_PART|HOME_PART|OS_NAME|OS_VERSION|OS_CODENAME|USERNAME)=' /sources/build-properties > /etc/aryalinux/build-settings

# LFS 9.2.2.1 - allow systemd-resolved to install its stub on first boot
rm -f /etc/resolv.conf

echo "config-files" >> /sources/build-log

fi

if ! grep initramfs /sources/build-log &> /dev/null
then
	/sources/initramfs.sh
fi


if ! grep lvm2 /sources/build-log &> /dev/null; then
	/sources/lvm2.sh
fi

if ! grep kernel /sources/build-log &> /dev/null
then
	/sources/kernel.sh
fi

for script in /sources/extras/*.sh
do
	$script
done

if ! grep syslinux /sources/build-log &> /dev/null
then

cd $SOURCE_DIR
tar xf syslinux-4.06.tar.xz
cd syslinux-4.06
cd utils
make
cp isohybrid /usr/bin/
cd $SOURCE_DIR
rm -r syslinux-4.06

echo "syslinux" >> /sources/build-log

fi

if ! grep "admin-user" /sources/build-log &> /dev/null
then

echo "Creating user with name $FULLNAME and username : $USERNAME"
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
usermod -a -G wheel $USERNAME

echo "admin-user" >> /sources/build-log

fi
