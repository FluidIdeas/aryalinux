#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:gnutls
#REQ:perl-modules#perl-parse-yapp
#REQ:rpcsvc-proto
#REQ:fuse
#REQ:icu
#REQ:mitkrb
#REQ:openldap

cd $SOURCE_DIR
NAME=samba
VERSION=4.23.5
URL=https://download.samba.org/pub/samba/stable/samba-4.23.5.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.samba.org/pub/samba/stable/samba-4.23.5.tar.gz


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

python3 -m venv --system-site-packages pyvenv
./pyvenv/bin/pip3 install cryptography pyasn1 iso8601
PYTHON=$PWD/pyvenv/bin/python3             \
./configure                                \
    --prefix=/usr                          \
    --sysconfdir=/etc                      \
    --localstatedir=/var                   \
    --with-piddir=/run/samba               \
    --with-pammodulesdir=/usr/lib/security \
    --enable-fhs                           \
    --without-ad-dc                        \
    --with-system-mitkrb5                  \
    --enable-selftest                      \
    --disable-rpath-install
make
sed '1s@^.*$@#!/usr/bin/python3@' \
    -i ./bin/default/source4/scripting/bin/*.inst
rm -rf /usr/lib/python3.14/site-packages/samba
sed -e "s;log file =.*;log file = /var/log/samba/%m.log;"   \
    -e "s;path = /usr/spool/samba;path = /var/spool/samba;" \
    -i /etc/samba/smb.conf.default
mkdir -pv /etc/openldap/schema
ln -v -sf /usr/bin/smbspool /usr/lib/cups/backend/smb


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m644 examples/smb.conf.default /etc/samba
install -v -m644    examples/LDAP/README \
                    /etc/openldap/schema/README.samba
install -v -m644    examples/LDAP/samba* \
                    /etc/openldap/schema
install -v -m755    examples/LDAP/{get*,ol*} \
                    /etc/openldap/schema
install -dvm 755 /usr/lib/cups/backend
make install-samba
make install-winbindd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd