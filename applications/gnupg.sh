#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libassuan
#REQ:npth
#REQ:gnutls

cd $SOURCE_DIR
NAME=gnupg
VERSION=2.5.17
URL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.17.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.17.tar.bz2


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

mkdir build
cd    build
../configure --prefix=/usr        \
             --localstatedir=/var \
             --sysconfdir=/etc    \
             --docdir=/usr/share/doc/gnupg-2.5.17
make
makeinfo --html --no-split -I doc -o doc/gnupg_nochunks.html ../doc/gnupg.texi
makeinfo --plaintext       -I doc -o doc/gnupg.txt           ../doc/gnupg.texi
make -C doc html
make -C doc pdf


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m755 -d /usr/share/doc/gnupg-2.5.17/html
install -v -m644    doc/gnupg_nochunks.html \
                    /usr/share/doc/gnupg-2.5.17/html/gnupg.html
install -v -m644    ../doc/*.texi doc/gnupg.txt \
                    /usr/share/doc/gnupg-2.5.17
install -v -m644    doc/gnupg.html/* \
                    /usr/share/doc/gnupg-2.5.17/html
install -v -m644 doc/gnupg.pdf \
                 /usr/share/doc/gnupg-2.5.17
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd