#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:nettle
#REC:make-ca
#REC:libunistring
#REC:libtasn1
#REC:p11-kit
#OPT:doxygen
#OPT:gtk-doc
#OPT:guile
#OPT:libidn
#OPT:libidn2
#OPT:net-tools
#OPT:texlive
#OPT:tl-installer
#OPT:unbound
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.19.tar.xz

URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.19.tar.xz

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
            --with-default-trust-store-pkcs11="pkcs11:" &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C doc/reference install-data-local
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
