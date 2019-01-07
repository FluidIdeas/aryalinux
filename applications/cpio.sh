#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:texlive

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2
wget -nc ftp://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2

NAME=cpio
VERSION=2.12.
URL=https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2

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
--bindir=/bin \
--enable-mt \
--with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html -o doc/html doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext -o doc/cpio.txt doc/cpio.texi
make -C doc pdf &&
make -C doc ps

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644 doc/html/* \
/usr/share/doc/cpio-2.12/html &&
install -v -m644 doc/cpio.{html,txt} \
/usr/share/doc/cpio-2.12
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 doc/cpio.{pdf,ps,dvi} \
/usr/share/doc/cpio-2.12
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
