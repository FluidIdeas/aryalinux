#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz


NAME=libunistring
VERSION=0.9.10
URL=https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz
SECTION="General Libraries"
DESCRIPTION="libunistring is a library that provides functions for manipulating Unicode strings and for manipulating C strings according to the Unicode standard."

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

echo $USER > /tmp/currentuser


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-0.9.10 &&
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

