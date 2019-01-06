#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:djbfft

cd $SOURCE_DIR

wget -nc http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz

NAME=liba52
VERSION=0.7.4
URL=http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz

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
--mandir=/usr/share/man \
--enable-shared \
--disable-static \
CFLAGS="-g -O2 $([ $(uname -m) = x86_64 ] && echo -fPIC)" &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
cp liba52/a52_internal.h /usr/include/a52dec &&
install -v -m644 -D doc/liba52.txt \
/usr/share/doc/liba52-0.7.4/liba52.txt
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
