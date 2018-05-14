#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="net-snmp"
VERSION="5.7.3"

cd $SOURCE_DIR

URL=downloads.sourceforge.net/net-snmp/net-snmp-5.7.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -nc $URL
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/net-snmp-5.7.3-fixes.patch

DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../net-snmp-5.7.3-fixes.patch &&
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
