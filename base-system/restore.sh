#!/bin/bash

set -e

read -p "Enter the backup directory path (/root/backup) : " BACKUP_DIR
read -p "Enter the directory to restore (/mnt/lfs) : " LFS
read -p "Enter the target partition. Please note that this partition would be formatted. e.g. /dev/sdX : " ROOT_PART
echo "Which backup you want to restore?"
echo "1. Base System"
echo "2. Base System with X Server"
echo "3. Base System with XFCE"
echo "4. Base System with Mate"
echo "5. Base System with KDE"
echo "6. Base System with Gnome"
read -p "Enter your choice (1 - 6) : " CHOICE

cat > build-properties <<EOF
LFS=$LFS
ROOT_DIR=$ROOT_DIR
CREATE_BACKUPS="y"
EOF

./umountal.sh
mkdir -pv $LFS
yes | mkfs.ext4 $ROOT_PART
mount $ROOT_PART $LFS
mkdir -pv $LFS/sources
ln -svf $LFS/sources /sources
cp -r * /sources/
if [ -d ~/sources ]; then
    cp -r ~/sources/* /sources/
fi

tar xf $BACKUP_DIR/toolchain-*-x86_64.tar.xz -C /
cp $BACKUP_DIR/toolchain-*-x86_64.tar.xz /sources/
if [ "x$CHOICE" == "x1" ]; then
    tar xf $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
elif [ "x$CHOICE" == "x2" ]; then
    tar xf $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz /sources/
elif [ "x$CHOICE" == "x3" ]; then
    tar xf $BACKUP_DIR/min/aryalinux-*-base-system-with-xfce-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/min/aryalinux-*-base-system-with-xfce-x86_64.tar.gz /sources/
elif [ "x$CHOICE" == "x4" ]; then
    tar xf $BACKUP_DIR/min/aryalinux-*-base-system-with-mate-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/min/aryalinux-*-base-system-with-mate-x86_64.tar.gz /sources/
elif [ "x$CHOICE" == "x5" ]; then
    tar xf $BACKUP_DIR/min/aryalinux-*-base-system-with-kde-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/min/aryalinux-*-base-system-with-kde-x86_64.tar.gz /sources/
elif [ "x$CHOICE" == "x6" ]; then
    tar xf $BACKUP_DIR/min/aryalinux-*-base-system-with-gnome-x86_64.tar.gz -C /
    cp $BACKUP_DIR/aryalinux-*-base-system-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/aryalinux-*-base-system-with-xserver-x86_64.tar.gz /sources/
    cp $BACKUP_DIR/min/aryalinux-*-base-system-with-gnome-x86_64.tar.gz /sources/
fi

cp ~/backup/build-log /sources
echo "5" > /sources/currentstage