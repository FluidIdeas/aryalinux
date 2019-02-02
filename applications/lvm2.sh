#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libaio

cd $SOURCE_DIR

wget -nc https://sourceware.org/ftp/lvm2/LVM2.2.03.02.tgz
wget -nc ftp://sourceware.org/pub/lvm2/LVM2.2.03.02.tgz

NAME=lvm2
VERSION=LVM2.2.03.02
URL=https://sourceware.org/ftp/lvm2/LVM2.2.03.02.tgz

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

SAVEPATH=$PATH &&
PATH=$PATH:/sbin:/usr/sbin &&
./configure --prefix=/usr \
--exec-prefix= \
--with-confdir=/etc \
--enable-cmdlib \
--enable-pkgconfig \
--enable-udev_sync &&
make &&
PATH=$SAVEPATH &&
unset SAVEPATH

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
