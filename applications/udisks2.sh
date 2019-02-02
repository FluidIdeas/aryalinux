#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libatasmart
#REQ:libblockdev
#REQ:libgudev
#REQ:libxslt
#REQ:polkit
#REQ:btrfs-progs
#REQ:dosfstools
#REQ:gptfdisk
#REQ:mdadm
#REQ:xfsprogs
#REC:systemd

cd $SOURCE_DIR

wget -nc https://github.com/storaged-project/udisks/releases/download/udisks-2.8.1/udisks-2.8.1.tar.bz2

NAME=udisks2
VERSION=2.8.1
URL=https://github.com/storaged-project/udisks/releases/download/udisks-2.8.1/udisks-2.8.1.tar.bz2

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
