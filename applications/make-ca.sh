#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:p11-kit
#OPT:java
#OPT:openjdk
#OPT:nss

cd $SOURCE_DIR

wget -nc https://github.com/djlucas/make-ca/releases/download/v1.2/make-ca-1.2.tar.xz

NAME=make-ca
VERSION=1.2
URL=https://github.com/djlucas/make-ca/releases/download/v1.2/make-ca-1.2.tar.xz

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

install -vdm755 /etc/ssl/local &&
wget http://www.cacert.org/certs/root.crt &&
wget http://www.cacert.org/certs/class3.crt &&
openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
-addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
> /etc/ssl/local/CAcert_Class_1_root.pem &&
openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
-addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
> /etc/ssl/local/CAcert_Class_3_root.pem

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
/usr/sbin/make-ca -g
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

ln -sfv /etc/pki/tls/certs/ca-bundle.crt \
/etc/ssl/ca-bundle.crt

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable update-pki.timer
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
