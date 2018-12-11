#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Cyrus SASL package contains abr3ak Simple Authentication and Security Layer, a method for addingbr3ak authentication support to connection-based protocols. To use SASL,br3ak a protocol includes a command for identifying and authenticating abr3ak user to a server and for optionally negotiating protection ofbr3ak subsequent protocol interactions. If its use is negotiated, abr3ak security layer is inserted between the protocol and the connection.br3ak"
SECTION="postlfs"
VERSION=2.1.26
NAME="cyrus-sasl"

#REC:db
#OPT:linux-pam
#OPT:mitkrb
#OPT:mariadb
#OPT:openjdk
#OPT:openldap
#OPT:postgresql
#OPT:sqlite


cd $SOURCE_DIR

URL=https://www.cyrusimap.org/releases/cyrus-sasl-2.1.26.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.cyrusimap.org/releases/cyrus-sasl-2.1.26.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/cyrus-sasl-2.1.26-fixes-3.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/cyrus-sasl/cyrus-sasl-2.1.26-fixes-3.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/cyrus-sasl-2.1.26-openssl-1.1.0-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/cyrus-sasl/cyrus-sasl-2.1.26-openssl-1.1.0-1.patch

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

patch -Np1 -i ../cyrus-sasl-2.1.26-fixes-3.patch &&
patch -Np1 -i ../cyrus-sasl-2.1.26-openssl-1.1.0-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-auth-sasldb \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-saslauthd=/var/run/saslauthd &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -m644  doc/{*.{html,txt,fig},ONEWS,TODO} \
    saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -dm700 /var/lib/sasl

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-saslauthd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
