#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/libpng/libpng-1.6.36.tar.xz
wget -nc https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.36-apng.patch.gz

NAME=libpng
VERSION=1.6.36
URL=https://downloads.sourceforge.net/libpng/libpng-1.6.36.tar.xz

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

gzip -cd ../libpng-1.6.36-apng.patch.gz | patch -p1
LIBS=-lpthread ./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mkdir -v /usr/share/doc/libpng-1.6.36 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.36
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
