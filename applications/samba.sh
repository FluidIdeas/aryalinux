#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:jansson
#REQ:libtirpc
#REQ:lmdb
#REQ:python2
#REQ:rpcsvc-proto
#REQ:fuse
#REQ:gpgme
#REQ:libxslt
#REQ:perl-modules#perl-parse-yapp
#REQ:python-modules#pycrypto
#REQ:openldap


cd $SOURCE_DIR

wget -nc https://www.samba.org/ftp/samba/stable/samba-4.10.7.tar.gz
wget -nc http://www.samba.org/samba/docs/using_samba/toc.html
wget -nc http://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/
wget -nc http://www.samba.org/samba/docs/man/Samba-Guide/


NAME=samba
VERSION=4.10.7
URL=https://www.samba.org/ftp/samba/stable/samba-4.10.7.tar.gz

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


echo "^samba4.rpc.echo.*on.*ncacn_np.*with.*object.*nt4_dc" >> selftest/knownfail
CFLAGS="-I/usr/include/tirpc"          \
LDFLAGS="-ltirpc"                      \
./configure                            \
    --prefix=/usr                      \
    --sysconfdir=/etc                  \
    --localstatedir=/var               \
    --with-piddir=/run/samba           \
    --with-pammodulesdir=/lib/security \
    --enable-fhs                       \
    --without-ad-dc                    \
    --enable-selftest                  &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

mv -v /usr/lib/libnss_win{s,bind}.so*   /lib                       &&
ln -v -sf ../../lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so &&
ln -v -sf ../../lib/libnss_wins.so.2    /usr/lib/libnss_wins.so    &&

install -v -m644    examples/smb.conf.default /etc/samba &&

mkdir -pv /etc/openldap/schema                        &&

install -v -m644    examples/LDAP/README              \
                    /etc/openldap/schema/README.LDAP  &&

install -v -m644    examples/LDAP/samba*              \
                    /etc/openldap/schema              &&

install -v -m755    examples/LDAP/{get*,ol*} \
                    /etc/openldap/schema
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -sf /usr/bin/smbspool /usr/lib/cups/backend/smb
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

