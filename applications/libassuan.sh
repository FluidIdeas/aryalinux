#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libgpg-error

cd $SOURCE_DIR
NAME=libassuan
VERSION=3.0.2
URL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2


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

./configure --prefix=/usr
make
make -C doc html
makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi
makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi
make -C doc pdf ps


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -dm755   /usr/share/doc/libassuan-3.0.2/html
install -v -m644 doc/assuan.html/* \
                    /usr/share/doc/libassuan-3.0.2/html
install -v -m644 doc/assuan_nochunks.html \
                    /usr/share/doc/libassuan-3.0.2
install -v -m644 doc/assuan.{txt,texi} \
                    /usr/share/doc/libassuan-3.0.2
install -v -m644  doc/assuan.{pdf,ps,dvi} \
                  /usr/share/doc/libassuan-3.0.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd