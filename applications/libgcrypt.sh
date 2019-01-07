#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libgpg-error
#OPT:pth
#OPT:texlive

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.4.tar.bz2

NAME=libgcrypt
VERSION=1.8.4.
URL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.4.tar.bz2

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

./configure --prefix=/usr &&
make
make -C doc pdf ps html &&
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
makeinfo --plaintext -o doc/gcrypt.txt doc/gcrypt.texi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/libgcrypt-1.8.4 &&
install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
/usr/share/doc/libgcrypt-1.8.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/libgcrypt-1.8.4/html &&
install -v -m644 doc/gcrypt.html/* \
/usr/share/doc/libgcrypt-1.8.4/html &&
install -v -m644 doc/gcrypt_nochunks.html \
/usr/share/doc/libgcrypt-1.8.4 &&
install -v -m644 doc/gcrypt.{pdf,ps,dvi,txt,texi} \
/usr/share/doc/libgcrypt-1.8.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
