#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenLDAP package provides anbr3ak open source implementation of the Lightweight Directory Accessbr3ak Protocol.br3ak"
SECTION="server"
VERSION=2.4.46
NAME="openldap"

#REC:cyrus-sasl
#OPT:icu
#OPT:gnutls
#OPT:pth
#OPT:unixodbc
#OPT:mariadb
#OPT:postgresql
#OPT:db


cd $SOURCE_DIR

URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.46.tgz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.46.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openldap/openldap-2.4.46.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openldap/openldap-2.4.46.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.46.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.46.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.46.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.46.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.4.46-consolidated-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openldap/openldap-2.4.46-consolidated-1.patch

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

patch -Np1 -i ../openldap-2.4.46-consolidated-1.patch &&
autoconf &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd &&
make depend &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
tar xf $TARBALL
cd $DIRECTORY



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 83 ldap &&
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../openldap-2.4.46-consolidated-1.patch &&
autoconf &&
./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --libexecdir=/usr/lib \
            --disable-static      \
            --disable-debug       \
            --with-tls=openssl    \
            --with-cyrus-sasl     \
            --enable-dynamic      \
            --enable-crypt        \
            --enable-spasswd      \
            --enable-slapd        \
            --enable-modules      \
            --enable-rlookups     \
            --enable-backends=mod \
            --disable-ndb         \
            --disable-sql         \
            --disable-shell       \
            --disable-bdb         \
            --disable-hdb         \
            --enable-overlays=mod &&
make depend &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
sed -e "s/\.la/.so/" -i /etc/openldap/slapd.{conf,ldif}{,.default} &&
install -v -dm700 -o ldap -g ldap /var/lib/openldap     &&
install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d &&
chmod   -v    640     /etc/openldap/slapd.{conf,ldif}   &&
chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}   &&
install -v -dm755 /usr/share/doc/openldap-2.4.46 &&
cp      -vfr      doc/{drafts,rfc,guide} \
                  /usr/share/doc/openldap-2.4.46

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
make install-slapd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
