#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

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
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:lvm2
#OPT:ntfs-3g

cd $SOURCE_DIR

wget -nc https://github.com/storaged-project/udisks/releases/download/udisks-2.8.1/udisks-2.8.1.tar.bz2

NAME=udisks2
VERSION=2.8.1.
URL=https://github.com/storaged-project/udisks/releases/download/udisks-2.8.1/udisks-2.8.1.tar.bz2

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make                             &&
sed -i -r 's/^ +\././' doc/man/*.[158]

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
