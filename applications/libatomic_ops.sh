#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR

wget -nc https://github.com/ivmai/libatomic_ops/releases/download/v7.6.8/libatomic_ops-7.6.8.tar.gz

NAME=libatomic_ops
VERSION=7.6.8
URL=https://github.com/ivmai/libatomic_ops/releases/download/v7.6.8/libatomic_ops-7.6.8.tar.gz

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

./configure --prefix=/usr \
--enable-shared \
--disable-static \
--docdir=/usr/share/doc/libatomic_ops-7.6.8 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
