#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc http://downloads.xvid.org/downloads/xvidcore-1.3.5.tar.gz

NAME=xvid
VERSION=1.3.5
URL=http://downloads.xvid.org/downloads/xvidcore-1.3.5.tar.gz

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

cd build/generic &&
sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile &&
make install &&

chmod -v 755 /usr/lib/libxvidcore.so.4.3 &&

install -v -m755 -d /usr/share/doc/xvidcore-1.3.5/examples &&
install -v -m644 ../../doc/* /usr/share/doc/xvidcore-1.3.5 &&
install -v -m644 ../../examples/* \
/usr/share/doc/xvidcore-1.3.5/examples
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
