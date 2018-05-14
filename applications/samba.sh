#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Samba package provides filebr3ak and print services to SMB/CIFS clients and Windows networking tobr3ak Linux clients. Samba can also bebr3ak configured as a Windows Domain Controller replacement, a file/printbr3ak server acting as a member of a Windows Active Directory domain andbr3ak a NetBIOS (rfc1001/1002) nameserver (which among other thingsbr3ak provides LAN browsing support).br3ak"
SECTION="basicnet"
VERSION=4.8.0
NAME="samba"

#REQ:libtirpc
#REQ:python2
#REQ:rpcsvc-proto
#REC:gpgme
#REC:libxslt
#REC:perl-modules#perl-parse-yapp
#REC:python-modules#pycrypto
#REC:openldap
#OPT:avahi
#OPT:cups
#OPT:cyrus-sasl
#OPT:gdb
#OPT:git
#OPT:gnupg
#OPT:gnutls
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
#OPT:xfsprogs
#OPT:python-modules#six


cd $SOURCE_DIR

URL=https://www.samba.org/ftp/samba/stable/samba-4.8.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.samba.org/ftp/samba/stable/samba-4.8.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/samba/samba-4.8.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/samba/samba-4.8.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/samba/samba-4.8.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/samba/samba-4.8.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/samba/samba-4.8.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/samba/samba-4.8.0.tar.gz

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

echo "^samba4.rpc.echo.*on.*ncacn_np.*with.*object.*nt4_dc" >> selftest/knownfail


CFLAGS="-I/usr/include/tirpc"          \
LDFLAGS="-ltirpc"                      \
  ./configure                          \
    --prefix=/usr                      \
    --sysconfdir=/etc                  \
    --localstatedir=/var               \
    --with-piddir=/run/samba           \
    --with-pammodulesdir=/lib/security \
    --enable-fhs                       \
    --without-ad-dc                    \
    --enable-selftest                  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ -L /var/lock ]; then
rm /var/lock
mkdir -pv /var/lock/subsys/
fi
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
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -sf /usr/bin/smbspool /usr/lib/cups/backend/smb

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
make install-samba

cd ..
rm -rf blfs-systemd-units-20180105
popd
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
make install-winbindd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
