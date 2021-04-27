#!/bin/bash

set -e
set +h

( ./umountal.sh && echo "Unmounted partition before performing actions..." ) || ( echo "Nothing mounted. Continuing..." )

. ./build-properties

export LFS=/mnt/lfs
mkdir -pv $LFS

mount $ROOT_PART $LFS

cat > $LFS/usr/bin/stripdebug <<"EOF"

/bin/find /usr/lib -type f -name \*.a \
-exec /usr/bin/strip --strip-debug {} ';'

/bin/find /lib /usr/lib -type f -name \*.so* \
-exec /usr/bin/strip --strip-unneeded {} ';'

/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
-exec /usr/bin/strip --strip-all {} ';'

DIRS="/opt/x-server
/opt/gnome
/opt/mate
/opt/xfce
/opt/qt5
/opt/kf5"

for DIR in $DIRS; do
	if [ -d $DIR ]; then
		echo "Stripping $DIR..."
		/bin/find $DIR/usr/lib -type f -name \*.a \
		-exec /usr/bin/strip --strip-debug {} ';'

		/bin/find $DIR/lib $DIR/usr/lib -type f -name \*.so* \
		-exec /usr/bin/strip --strip-unneeded {} ';'

		/bin/find $DIR/{bin,sbin} $DIR/usr/{bin,sbin,libexec} -type f \
		-exec /usr/bin/strip --strip-all {} ';'
	fi
done

EOF

chmod a+x $LFS/usr/bin/stripdebug

chroot $LFS /usr/bin/env -i            \
HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
/bin/bash --login /usr/bin/stripdebug

rm $LFS/usr/bin/stripdebug

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
