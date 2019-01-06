#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:tcl
#OPT:tk

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz

NAME=expect
VERSION=""
URL=https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz

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
--with-tcl=/usr/lib \
--enable-shared \
--mandir=/usr/share/man \
--with-tclinclude=/usr/include &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
