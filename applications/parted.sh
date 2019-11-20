#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:lvm2


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/parted/parted-3.3.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/parted/parted-3.3.tar.xz


NAME=parted
VERSION=3.3
URL=https://ftp.gnu.org/gnu/parted/parted-3.3.tar.xz

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


./configure --prefix=/usr --disable-static &&
make &&

make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/parted-3.3/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.3/html &&
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

