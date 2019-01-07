#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:db
#REC:cyrus-sasl
#REC:libnsl
#OPT:icu
#OPT:mariadb
#OPT:openldap
#OPT:pcre
#OPT:postgresql
#OPT:sqlite
#OPT:cdb
#OPT:tinycdb

cd $SOURCE_DIR

wget -nc ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.3.2.tar.gz

NAME=postfix
VERSION=3.3.2
URL=ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.3.2.tar.gz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 32 postfix &&
groupadd -g 33 postdrop &&
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
-s /bin/false -u 32 postfix &&
chown -v postfix:postfix /var/mail
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i 's/.\x08//g' README_FILES/*
make CCARGS="-DUSE_TLS -I/usr/include/openssl/ \
-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl" \
AUXLIBS="-lssl -lcrypto -lsasl2" \
makefiles &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sh postfix-install -non-interactive \
daemon_directory=/usr/lib/postfix \
manpage_directory=/usr/share/man \
html_directory=/usr/share/doc/postfix-3.3.2/html \
readme_directory=/usr/share/doc/postfix-3.3.2/readme
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/aliases << "EOF"
# Begin /etc/aliases

MAILER-DAEMON: postmaster
postmaster: root

<em class="replaceable"><code><LOGIN></em>
# End /etc/aliases
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
/usr/sbin/postfix upgrade-configuration
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
/usr/sbin/postfix check &&
/usr/sbin/postfix start
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-postfix
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
