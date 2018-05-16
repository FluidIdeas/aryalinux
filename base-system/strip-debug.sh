#!/bin/bash

set -e
set +h

( ./umountal.sh keepoverlay && echo "Unmounted partition before performing actions..." ) || ( echo "Nothing mounted. Continuing..." )

. ./build-properties

export LFS=/mnt/lfs
mkdir -pv $LFS

# mount $ROOT_PART $LFS

cat > $LFS/tools/bin/stripdebug <<EOF
/tools/bin/find /usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /lib /usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'

if [ -L /opt/qt5 ]; then
/tools/bin/find /opt/qt5/usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /opt/qt5/lib /opt/qt5/usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /opt/qt5/{bin,sbin} /opt/qt5/usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'
fi

if [ -L /opt/kf5 ]; then
/tools/bin/find /opt/kf5/usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /opt/kf5/lib /opt/kf5/usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /opt/kf5/{bin,sbin} /opt/kf5/usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'
fi 

EOF

chmod a+x $LFS/tools/bin/stripdebug

chroot $LFS /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login /tools/bin/stripdebug

rm $LFS/tools/bin/stripdebug

# Now unmount the overlay because grub has to be reinstalled in the base system

umount $LFS

sleep 5

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -vt tmpfs tmpfs $LFS/dev/shm

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/fix-grub.sh

# Unmount everything except the root partition

./umountal.sh
