#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:nettle
#REQ:make-ca
#REQ:libunistring
#REQ:libtasn1
#REQ:p11-kit


cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.11.1.tar.xz
wget -nc ftp://ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.11.1.tar.xz


NAME=gnutls
VERSION=3.6.11.1
URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.11.1.tar.xz

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


./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.6.11.1 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C doc/reference install-data-local
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

