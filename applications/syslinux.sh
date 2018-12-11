#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="syslinux"
VERSION="6.03"

cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

if [ `uname -m` != "x86_64" ]
then
	make bios efi32
else
	make
fi
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
