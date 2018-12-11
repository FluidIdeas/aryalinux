#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libtirpc
#OPT:clucene
#OPT:icu
#OPT:libcap
#OPT:linux-pam
#OPT:lua
#OPT:mariadb
#OPT:mitkrb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://www.dovecot.org/releases/2.3/dovecot-2.3.3.tar.gz

URL=https://www.dovecot.org/releases/2.3/dovecot-2.3.3.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 42 dovecot &&
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot &&
groupadd -g 43 dovenull &&
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

sed -e "s;#include <unistd.h>;&\n#include <crypt.h>;" \
    -i src/auth/mycrypt.c
CFLAGS+=" -I/usr/include/tirpc" \
LDFLAGS+=" -ltirpc" \
./configure --prefix=/usr                          \
            --sysconfdir=/etc                      \
            --localstatedir=/var                   \
            --docdir=/usr/share/doc/dovecot-2.3.3 \
            --disable-static                       \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cp -rv /usr/share/doc/dovecot-2.3.3/example-config/* /etc/dovecot
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
sed -i '/^\!include / s/^/#/' /etc/dovecot/dovecot.conf &&
chmod -v 1777 /var/mail &&
cat > /etc/dovecot/local.conf << "EOF"
<code class="literal">protocols = imap ssl = no # The next line is only needed if you have no IPv6 network interfaces listen = * mail_location = mbox:~/Mail:INBOX=/var/mail/%u userdb { driver = passwd } passdb { driver = shadow }</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable dovecot
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
