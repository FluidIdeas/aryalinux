#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REC:aspell
#OPT:dbus-glib

cd $SOURCE_DIR

wget -nc https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz

NAME=enchant
VERSION=2.2.3
URL=https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz

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

./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -rf /usr/include/enchant &&
ln -sfv enchant-2 /usr/include/enchant &&
ln -sfv enchant-2 /usr/bin/enchant &&
ln -sfv libenchant-2.so /usr/lib/libenchant.so &&
ln -sfv enchant-2.pc /usr/lib/pkgconfig/enchant.pc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > /tmp/test-enchant.txt << "EOF"
Tel me more abot linux
Ther ar so many commads
EOF

enchant -d en_GB -l /tmp/test-enchant.txt &&
enchant -d en_GB -a /tmp/test-enchant.txt

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
