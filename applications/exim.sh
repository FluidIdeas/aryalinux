#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libnsl
#REQ:pcre
#OPT:cyrus-sasl
#OPT:libidn
#OPT:linux-pam
#OPT:mariadb
#OPT:openldap
#OPT:gnutls
#OPT:postgresql
#OPT:sqlite
#OPT:installing

cd $SOURCE_DIR

wget -nc http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.91.tar.xz
wget -nc ftp://ftp.exim.org/pub/exim/exim4/exim-4.91.tar.xz

NAME=exim
VERSION=4.91
URL=http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.91.tar.xz

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
groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

sed -e 's,^BIN_DIR.*$,BIN_DIRECTORY=/usr/sbin,'    \
    -e 's,^CONF.*$,CONFIGURE_FILE=/etc/exim.conf,' \
    -e 's,^EXIM_USER.*$,EXIM_USER=exim,'           \
    -e '/SUPPORT_TLS/s,^#,,'                       \
    -e '/USE_OPENSSL/s,^#,,'                       \
    -e 's,^EXIM_MONITOR,#EXIM_MONITOR,' src/EDITME > Local/Makefile &&

printf "USE_GDBM = yes\nDBMLIB = -lgdbm\n" >> Local/Makefile &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install                                    &&
install -v -m644 doc/exim.8 /usr/share/man/man8 &&

install -v -d -m755    /usr/share/doc/exim-4.91 &&
install -v -m644 doc/* /usr/share/doc/exim-4.91 &&

ln -sfv exim /usr/sbin/sendmail                 &&
install -v -d -m750 -o exim -g exim /var/spool/exim
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
chmod -v a+wt /var/mail
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/aliases << "EOF"
<code class="literal">postmaster: root MAILER-DAEMON: root</code>
EOF
exim -v -bi &&
/usr/sbin/exim -bd -q15m
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-exim
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
