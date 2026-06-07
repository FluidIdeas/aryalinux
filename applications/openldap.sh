#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cyrus-sasl

cd $SOURCE_DIR
NAME=openldap
VERSION=2.6.12
URL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.12.tgz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.12.tgz


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

patch -Np1 -i ../openldap-2.6.12-consolidated-1.patch
autoconf
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd
make depend
make
patch -Np1 -i ../openldap-2.6.12-consolidated-1.patch
autoconf
./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --libexecdir=/usr/lib \
            --disable-static      \
            --disable-debug       \
            --with-tls=openssl    \
            --with-cyrus-sasl     \
            --without-systemd     \
            --enable-dynamic      \
            --enable-crypt        \
            --enable-spasswd      \
            --enable-slapd        \
            --enable-modules      \
            --enable-rlookups     \
            --enable-backends=mod \
            --disable-sql         \
            --disable-wt          \
            --enable-overlays=mod
make depend
make
ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
groupadd -g 83 ldap
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap
sed -e "s/\.la/.so/" -i /etc/openldap/slapd.{conf,ldif}{,.default}
chmod   -v    640     /etc/openldap/slapd.{conf,ldif}
chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}
cp      -vfr      doc/{drafts,rfc,guide} \
                  /usr/share/doc/openldap-2.6.12
systemctl start slapd


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
make install
install -v -dm700 -o ldap -g ldap /var/lib/openldap
install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d
install -v -dm755 /usr/share/doc/openldap-2.6.12
make install-slapd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd