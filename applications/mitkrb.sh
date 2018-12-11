#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:dejagnu
#OPT:gnupg
#OPT:keyutils
#OPT:openldap
#OPT:python2
#OPT:rpcbind
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://kerberos.org/dist/krb5/1.16/krb5-1.16.2.tar.gz

URL=https://kerberos.org/dist/krb5/1.16/krb5-1.16.2.tar.gz

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
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
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

install -v -dm755 /usr/share/doc/krb5-1.16.2 &&
cp -vfr ../doc/*  /usr/share/doc/krb5-1.16.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/krb5.conf << "EOF"
<code class="literal"># Begin /etc/krb5.conf [libdefaults] default_realm = <em class="replaceable"><code><EXAMPLE.ORG></code></em> encrypt = true [realms] <em class="replaceable"><code><EXAMPLE.ORG></code></em> = { kdc = <em class="replaceable"><code><belgarath.example.org></code></em> admin_server = <em class="replaceable"><code><belgarath.example.org></code></em> dict_file = /usr/share/dict/words } [domain_realm] .<em class="replaceable"><code><example.org></code></em> = <em class="replaceable"><code><EXAMPLE.ORG></code></em> [logging] kdc = SYSLOG:INFO:AUTH admin_server = SYSLOG:INFO:AUTH default = SYSLOG:DEBUG:DAEMON # End /etc/krb5.conf</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
kdb5_util create -r <em class="replaceable"><code><EXAMPLE.ORG></code></em> -s
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
kadmin.local
<code class="prompt">kadmin.local:</code> add_policy dict-only
<code class="prompt">kadmin.local:</code> addprinc -policy dict-only <em class="replaceable"><code><loginname></code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
<code class="prompt">kadmin.local:</code> addprinc -randkey host/<em class="replaceable"><code><belgarath.example.org></code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
<code class="prompt">kadmin.local:</code> ktadd host/<em class="replaceable"><code><belgarath.example.org></code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
/usr/sbin/krb5kdc
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

kinit <em class="replaceable"><code><loginname></code></em>
klist
ktutil
<code class="prompt">ktutil:</code> rkt /etc/krb5.keytab
<code class="prompt">ktutil:</code> l

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-krb5
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
