#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="kmod"
VERSION="23"

URL=https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-23.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure \
  --prefix=/usr \
  --libdir=/lib \
  --bindir=/sbin \
  --sbindir=/sbin \
  --sysconfdir=/etc \
  --localstatedir=/var \
  --mandir=/usr/man \
  --with-xz \
  --with-zlib  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
