#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:jansson
#REQ:libtirpc
#REQ:lmdb
#REQ:python2
#REQ:rpcsvc-proto
#REC:fuse
#REC:gpgme
#REC:libxslt
#REC:perl-parse-yapp
#REC:pycrypto
#REC:openldap
#OPT:avahi
#OPT:cups
#OPT:cyrus-sasl
#OPT:gdb
#OPT:git
#OPT:gnupg
#OPT:gnutls
#OPT:jansson
#OPT:libaio
#OPT:libarchive
#OPT:libcap
#OPT:libgcrypt
#OPT:libnsl
#OPT:linux-pam
#OPT:mitkrb
#OPT:nss
#OPT:popt
#OPT:talloc
#OPT:vala
#OPT:valgrind
#OPT:wireshark
#OPT:xfsprogs
#OPT:six

cd $SOURCE_DIR

wget -nc https://www.samba.org/ftp/samba/stable/samba-4.9.4.tar.gz

NAME=samba
VERSION=4.9.4
URL=https://www.samba.org/ftp/samba/stable/samba-4.9.4.tar.gz

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

echo "^samba4.rpc.echo.*on.*ncacn_np.*with.*object.*nt4_dc" >> selftest/knownfail
CFLAGS="-I/usr/include/tirpc" \
LDFLAGS="-ltirpc" \
./configure \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--with-piddir=/run/samba \
--with-pammodulesdir=/lib/security \
--enable-fhs \
--without-ad-dc \
--enable-selftest &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

mv -v /usr/lib/libnss_win{s,bind}.so* /lib &&
ln -v -sf ../../lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so &&
ln -v -sf ../../lib/libnss_wins.so.2 /usr/lib/libnss_wins.so &&

install -v -m644 examples/smb.conf.default /etc/samba &&

mkdir -pv /etc/openldap/schema &&

install -v -m644 examples/LDAP/README \
/etc/openldap/schema/README.LDAP &&

install -v -m644 examples/LDAP/samba* \
/etc/openldap/schema &&

install -v -m755 examples/LDAP/{get*,ol*} \
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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-samba
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-winbindd
popd
popd


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl stop smbd &&
systemctl disable smbd &&
systemctl enable smbd.socket &&
systemctl start smbd.socket
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
