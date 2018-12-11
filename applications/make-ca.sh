#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Public Key Infrastructure (PKI) is a method to validate thebr3ak authenticity of an otherwise unknown entity across untrustedbr3ak networks. PKI works by establishing a chain of trust, rather thanbr3ak trusting each individual host or entity explicitly. In order for abr3ak certificate presented by a remote entity to be trusted, thatbr3ak certificate must present a complete chain of certificates that canbr3ak be validated using the root certificate of a Certificate Authoritybr3ak (CA) that is trusted by the local machine.br3ak"
SECTION="postlfs"
VERSION=0.9
NAME="make-ca"

#REQ:p11-kit
#OPT:java
#OPT:openjdk
#OPT:nss


cd $SOURCE_DIR

URL=https://github.com/djlucas/make-ca/archive/v0.9/make-ca-0.9.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/djlucas/make-ca/archive/v0.9/make-ca-0.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/make-ca/make-ca-0.9.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

install -vdm755 /etc/ssl/local &&
wget http://www.cacert.org/certs/root.crt &&
wget http://www.cacert.org/certs/class3.crt &&
openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_1_root.pem &&
openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_3_root.pem



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                             &&
mkdir -pv /etc/pki/tls/certs             &&
ln -svf /etc/ssl/ca-bundle.crt \
        /etc/pki/tls/certs/ca-bundle.crt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/usr/sbin/make-ca -g

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
