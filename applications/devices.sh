#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR


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

mount --bind / /mnt
cp -a /dev/* /mnt/dev
rm /etc/rc.d/rcS.d/{S10udev,S50udev_retry}
umount /mnt
sed '1d;/SYMLINK.*cdrom/ a\
KERNEL=="sr0", ENV{ID_CDROM_DVD}=="1", SYMLINK+="dvd", OPTIONS+="link_priority=-100"' \
/lib/udev/rules.d/60-cdrom_id.rules > /etc/udev/rules.d/60-cdrom_id.rules

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
