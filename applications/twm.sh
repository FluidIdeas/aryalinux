#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:xorg-server

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/app/twm-1.0.10.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/app/twm-1.0.10.tar.bz2

NAME=twm
VERSION=1.0.10.
URL=https://www.x.org/pub/individual/app/twm-1.0.10.tar.bz2

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

sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in &&
./configure $XORG_CONFIG &&
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
