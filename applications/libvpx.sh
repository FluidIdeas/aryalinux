#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:yasm
#REQ:nasm
#REQ:which

cd $SOURCE_DIR

wget -nc https://github.com/webmproject/libvpx/archive/v1.7.0/libvpx-1.7.0.tar.gz

NAME=libvpx
VERSION=1.7.0
URL=https://github.com/webmproject/libvpx/archive/v1.7.0/libvpx-1.7.0.tar.gz

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

sed -i 's/cp -p/cp/' build/make/Makefile &&

mkdir libvpx-build &&
cd libvpx-build &&

../configure --prefix=/usr \
--enable-shared \
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
