#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak MIT Kerberos V5 is a freebr3ak implementation of Kerberos 5. Kerberos is a network authenticationbr3ak protocol. It centralizes the authentication database and usesbr3ak kerberized applications to work with servers or services thatbr3ak support Kerberos allowing single logins and encrypted communicationbr3ak over internal networks or the Internet.br3ak"
SECTION="postlfs"
VERSION=1.16
NAME="mitkrb"

#OPT:dejagnu
#OPT:gnupg
#OPT:keyutils
#OPT:openldap
#OPT:python2
#OPT:rpcbind
#OPT:valgrind


cd $SOURCE_DIR

URL=https://web.mit.edu/kerberos/dist/krb5/1.16/krb5-1.16.tar.gz

if [ ! -z $URL ]
then
wget -nc https://web.mit.edu/kerberos/dist/krb5/1.16/krb5-1.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/krb5/krb5-1.16.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/krb5/krb5-1.16.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/krb5/krb5-1.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/krb5/krb5-1.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/krb5/krb5-1.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/krb5/krb5-1.16.tar.gz

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

cd src &&
 
sed -i -e 's@\^u}@^u cols 300}@' tests/dejagnu/config/default.exp     &&
sed -i -e '/eq 0/{N;s/12 //}'    plugins/kdb/db2/libdb2/test/run.test &&
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
for f in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
         kdb5 kdb_ldap krad krb5 krb5support verto ; do
    find /usr/lib -type f -name "lib$f*.so*" -exec chmod -v 755 {} \;    
done          &&
mv -v /usr/lib/libkrb5.so.3*        /lib &&
mv -v /usr/lib/libk5crypto.so.3*    /lib &&
mv -v /usr/lib/libkrb5support.so.0* /lib &&
ln -v -sf ../../lib/libkrb5.so.3.3        /usr/lib/libkrb5.so        &&
ln -v -sf ../../lib/libk5crypto.so.3.1    /usr/lib/libk5crypto.so    &&
ln -v -sf ../../lib/libkrb5support.so.0.1 /usr/lib/libkrb5support.so &&
mv -v /usr/bin/ksu /bin &&
chmod -v 755 /bin/ksu   &&
install -v -dm755 /usr/share/doc/krb5-1.16 &&
cp -vfr ../doc/*  /usr/share/doc/krb5-1.16

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
make install-krb5

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
