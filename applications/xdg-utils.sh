#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:xmlto
#REQ:lynx
#REQ:w3m
#REQ:links
#REQ:x7app
#OPT:dbus

cd $SOURCE_DIR

wget -nc https://portland.freedesktop.org/download/xdg-utils-1.1.3.tar.gz

NAME=xdg-utils
VERSION=1.1.3
URL=https://portland.freedesktop.org/download/xdg-utils-1.1.3.tar.gz

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

./configure --prefix=/usr --mandir=/usr/share/man &&
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
