#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cyrus-sasl


cd $SOURCE_DIR

wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.4.47-consolidated-1.patch
wget -nc http://www.openldap.org/doc/admin24/
wget -nc http://www.openldap.org/pub/


NAME=openldap
VERSION=2.4.47
URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz

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


patch -Np1 -i ../openldap-2.4.47-consolidated-1.patch &&
autoconf &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd &&

make depend &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install

ln -sf ../lib/slapd /usr/sbin/slapd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 83 ldap &&
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

patch -Np1 -i ../openldap-2.4.47-consolidated-1.patch &&
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
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

sed -e "s/\.la/.so/" -i /etc/openldap/slapd.{conf,ldif}{,.default} &&

install -v -dm700 -o ldap -g ldap /var/lib/openldap     &&

install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d &&
chmod   -v    640     /etc/openldap/slapd.{conf,ldif}   &&
chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}   &&

install -v -dm755 /usr/share/doc/openldap-2.4.47 &&
cp      -vfr      doc/{drafts,rfc,guide} \
                  /usr/share/doc/openldap-2.4.47
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
sudo make install-slapd
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl start slapd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

