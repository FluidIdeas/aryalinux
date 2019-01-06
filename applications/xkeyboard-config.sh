#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:x7lib

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2

NAME=xkeyboard-config
VERSION=2.25.
URL=https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.25.tar.bz2

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

./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg &&
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
