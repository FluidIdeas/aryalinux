#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libgpg-error


cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2
wget -nc ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.3.tar.bz2


NAME=libassuan
VERSION=2.5.3
URL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2

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


./configure --prefix=/usr &&
make                      &&

make -C doc html                                                       &&
makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi &&
makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -dm755   /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan.html/* \
                    /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan_nochunks.html \
                    /usr/share/doc/libassuan-2.5.3      &&
install -v -m644 doc/assuan.{txt,texi} \
                    /usr/share/doc/libassuan-2.5.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

