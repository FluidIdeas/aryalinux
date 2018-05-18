#!/bin/bash

./umountal.sh

LFS=/mnt/lfs
mkdir -pv $LFS

. ./build-properties

set -e

if [ $# -ne 0 ]
then

for i in "$@"
do
case $i in
    -r=*|--root-partition=*)
    ROOT_PART="${i#*=}"
    shift # past argument=value
    ;;
    -h=*|--home-partition=*)
    HOME_PART="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--label=*)
    LABEL="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--output=*)
    OUTFILE="${i#*=}"
    shift # past argument=value
    ;;
    -u=*|--default-user=*)
    USERNAME="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--create-squashedfs=*)
    CREATE_ROOTSFS="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
            # unknown option
    ;;
esac
done

else

if [ "x$INSTALL_DESKTOP_ENVIRONMENT" == "xy" ]; then
	if [ "x$DESKTOP_ENVIRONMENT" == "x1" ]; then
		DE="XFCE"
	elif [ "x$DESKTOP_ENVIRONMENT" == "x2" ]; then
		DE="Mate";
	elif [ "x$DESKTOP_ENVIRONMENT" == "x3" ]; then
		DE="KDE5"
	elif [ "x$DESKTOP_ENVIRONMENT" == "x4" ]; then
		DE="GNOME"
	else
		DE="Builder"
	fi
	LABEL="$OS_NAME $DE $OS_VERSION"
else
	LABEL="$OS_NAME $OS_VERSION"
fi

if [ "x$DE" != "x" ]
then
	OUTFILE="$(echo $OS_NAME | tr '[:upper:]' [:lower:])-$(echo $DE | tr '[:upper:]' '[:lower:]')-$OS_VERSION-$(uname -m).iso"
else
	OUTFILE="$(echo $OS_NAME | tr '[:upper:]' [:lower:])-$OS_VERSION-$(uname -m).iso"
fi

CREATE_ROOTSFS="y"

fi

if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -vt tmpfs tmpfs $LFS/dev/shm

cp -v make-efibootimg.sh $LFS/sources/
cp -v mkliveinitramfs.sh $LFS/sources/
cp -v init.sh $LFS/sources/

chmod a+x $LFS/sources/*.sh

if [ `uname -m` == "x86_64" ]
then

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/make-efibootimg.sh "$LABEL"

fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/mkliveinitramfs.sh

XSERVER="$LFS/opt/x-server"
DE="$LFS/opt/desktop-environment"

if [ -d "$XSERVER" ]; then
    if [ -d "$DE" ]; then
        if ! mount | grep "overlay on $LFS" &> /dev/null; then
            mount -t overlay -olowerdir=$XSERVER:$LFS,upperdir=$DE,workdir=$LFS/tmp overlay $LFS
        fi
    else
        if ! mount | grep "overlay on $LFS" &> /dev/null; then
            mount -t overlay -olowerdir=$LFS,upperdir=$XSERVER,workdir=$LFS/tmp overlay $LFS
        fi
    fi
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    groupadd -rf autologin

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    usermod -a -G autologin $USERNAME

umount $LFS

sleep 5
set +e
./umountal.sh all
set -e

mount $ROOT_PART $LFS

if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

if [ -f $LFS/etc/lightdm/lightdm.conf ]
then
	sed -i "s@#autologin-user=@autologin-user=$USERNAME@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#autologin-user-timeout=0@autologin-user-timeout=0@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#pam-service=lightdm-autologin@pam-service=lightdm-autologin@g" $LFS/etc/lightdm/lightdm.conf
else
	mkdir -pv $LFS/etc/systemd/system/getty@tty1.service.d/
	pushd $LFS/etc/systemd/system/getty@tty1.service.d/
cat >override.conf<<EOF
[Service]
Type=simple
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I 38400 linux
EOF
	popd
fi

# Let's unmount everything to create the squashed filesystem
./umountal.sh

rm -f $LFS/sources/root.sfs
OPTIONS=""
DIRS="
/sources
/home/$USERNAME/.ccache
/root/.ccache
/var/cache/alps/sources/app
/var/cache/alps/sources/font
/var/cache/alps/sources/lib
/var/cache/alps/sources/proto
/var/cache/alps/sources/*
/var/cache/alps/binaries/*
"

OPTDIRS="
x-server
gnome
xfce
kde
mate"

for OPTDIR in $OPTDIRS; do
    if [ -d $LFS/opt/$OPTDIR ]; then
        for DIR in $DIRS; do
            OPTIONS="$OPTIONS -e $LFS/opt/$OPTDIR/$DIR"
        done
    fi
done
sudo mksquashfs $LFS $LFS/sources/root.sfs -b 1048576 -comp xz -Xdict-size 100% \
    -e $LFS/etc/fstab \
    -e $LFS/sources \
    -e $LFS/tools \
    -e $LFS/$USERNAME/.ccache \
    -e $LFS/root/.ccache \
    -e $LFS/var/cache/alps/sources/* \
    -e $LFS/var/cache/alps/binaries/* \
    $OPTIONS


# Now mount the overlay so that we can revert back the changes we have made

XSERVER="$LFS/opt/x-server"
DE="$LFS/opt/desktop-environment"

if [ -d "$XSERVER" ]; then
    if [ -d "$DE" ]; then
        if ! mount | grep "overlay on $LFS" &> /dev/null; then
            mount -t overlay -olowerdir=$XSERVER:$LFS,upperdir=$DE,workdir=$LFS/tmp overlay $LFS
        fi
    else
        if ! mount | grep "overlay on $LFS" &> /dev/null; then
            mount -t overlay -olowerdir=$LFS,upperdir=$XSERVER,workdir=$LFS/tmp overlay $LFS
        fi
    fi
fi

if [ -f $LFS/etc/lightdm/lightdm.conf ]
then
	sed -i "s@autologin-user=$USERNAME@#autologin-user=@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@autologin-user-timeout=0@#autologin-user-timeout=0@g" $LFS/etc/lightdm/lightdm.conf
    sed -i "s@pam-service=lightdm-autologin@#pam-service=lightdm-autologin@g" $LFS/etc/lightdm/lightdm.conf
else
	rm -fv /etc/systemd/system/getty@tty1.service.d/override.conf
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    gpasswd -d $USERNAME autologin

./umountal.sh

cd $LFS/sources/

tar xf $LFS/sources/syslinux-4.06.tar.xz
rm -fr live

mkdir -pv live/aryalinux
mkdir -pv live/isolinux

if [ `uname -m` == "x86_64" ]
then

mkdir -pv live/EFI/BOOT
cp -v $LFS/sources/efiboot.img live/isolinux/
cp -v $LFS/sources/bootx64.efi live/EFI/BOOT/
cat > live/EFI/BOOT/grub.cfg << EOF
set default="0"
set timeout="30"
set hidden_timeout_quiet=false

menuentry "$LABEL"{
  echo "Loading AryaLinux.  Please wait..."
  linux /isolinux/vmlinuz quiet splash
  initrd /isolinux/initram.fs
}

menuentry "$LABEL Debug Mode"{
  echo "Loading AryaLinux in debug mode.  Please wait..."
  linux /isolinux/vmlinuz
  initrd /isolinux/initram.fs
}
EOF

fi

echo "AryaLinux Live" >id_label

cp -v id_label live/isolinux
cp -v syslinux-4.06/core/isolinux.bin live/isolinux
cp -v syslinux-4.06/com32/menu/menu.c32 live/isolinux

cat > live/isolinux/isolinux.cfg << EOF
DEFAULT menu.c32
PROMPT 0
MENU TITLE Select an option to boot Aryalinux
TIMEOUT 300

LABEL slientlive
    MENU LABEL $LABEL
    MENU DEFAULT
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs quiet splash
LABEL debuglive
    MENU LABEL $LABEL Debug Mode
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs
EOF

cp -v $LFS/sources/root.sfs live/aryalinux/
cp -v `ls $LFS/boot/vmlinuz*`   live/isolinux/vmlinuz
cp -v $LFS/boot/initram.fs live/isolinux/

echo "AryaLinux Live" > live/isolinux/id_label


if [ `uname -m` == "x86_64" ]
then
mkisofs -o $LFS/sources/$OUTFILE -R -J -A "$LABEL" -hide-rr-moved -v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -eltorito-alt-boot -no-emul-boot -eltorito-platform 0xEF -eltorito-boot isolinux/efiboot.img -V "ARYALIVE" live
isohybrid -u $LFS/sources/$OUTFILE
else
mkisofs -o $LFS/sources/$OUTFILE -R -J -A "$LABEL" -hide-rr-moved -v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -no-emul-boot -V "ARYALIVE" live
isohybrid $LFS/sources/$OUTFILE
fi

rm -rvf $LFS/boot/initram.fs
rm -rvf $LFS/boot/id_label

./umountal.sh