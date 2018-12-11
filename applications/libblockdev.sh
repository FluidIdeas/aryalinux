#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gobject-introspection
#REQ:libbytesize
#REQ:parted
#REQ:volume_key
#REQ:yaml
#OPT:btrfs-progs
#OPT:gtk-doc
#OPT:mdadm

cd $SOURCE_DIR

wget -nc https://github.com/storaged-project/libblockdev/releases/download/2.20-1/libblockdev-2.20.tar.gz

NAME=libblockdev
VERSION=2.20
URL=https://github.com/storaged-project/libblockdev/releases/download/2.20-1/libblockdev-2.20.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-python3    \
            --without-gtk-doc \
            --without-nvdimm  \
            --without-dm      &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
