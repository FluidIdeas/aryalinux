#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=mitkrb
VERSION=1.19.1
URL=https://kerberos.org/dist/krb5/1.19/krb5-1.19.1.tar.gz
SECTION="Security"
DESCRIPTION="MIT Kerberos V5 is a free implementation of Kerberos 5. Kerberos is a network authentication protocol. It centralizes the authentication database and uses kerberized applications to work with servers or services that support Kerberos allowing single logins and encrypted communication over internal networks or the Internet."


mkdir -pv $NAME
pushd $NAME

wget -nc https://kerberos.org/dist/krb5/1.19/krb5-1.19.1.tar.gz


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


cd src &&

sed -i -e 's@\^u}@^u cols 300}@' tests/dejagnu/config/default.exp     &&
sed -i -e '/eq 0/{N;s/12 //}'    plugins/kdb/db2/libdb2/test/run.test &&
sed -i '/t_iprop.py/d'           tests/Makefile.in                    &&

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --runstatedir=/run       \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

mv -v /usr/lib/libkrb5.so.3*        /lib &&
mv -v /usr/lib/libk5crypto.so.3*    /lib &&
mv -v /usr/lib/libkrb5support.so.0* /lib &&

ln -v -sf ../../lib/libkrb5.so.3.3        /usr/lib/libkrb5.so        &&
ln -v -sf ../../lib/libk5crypto.so.3.1    /usr/lib/libk5crypto.so    &&
ln -v -sf ../../lib/libkrb5support.so.0.1 /usr/lib/libkrb5support.so &&

mv -v /usr/bin/ksu /bin &&
chmod -v 755 /bin/ksu   &&

install -v -dm755 /usr/share/doc/krb5-1.19.1 &&
cp -vfr ../doc/*  /usr/share/doc/krb5-1.19.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
touch /var/lib/krb5kdc/kadm5.acl
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd