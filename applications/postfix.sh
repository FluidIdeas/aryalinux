#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cyrus-sasl
#REQ:lmdb

cd $SOURCE_DIR
NAME=postfix
VERSION=3.10.8
URL=https://ghostarchive.org/postfix/postfix-release/official/postfix-3.10.8.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ghostarchive.org/postfix/postfix-release/official/postfix-3.10.8.tar.gz


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

sed -i 's/.\x08//g' README_FILES/*
CCARGS="-DNO_NIS -DNO_DB"
AUXLIBS=""
if [ -r /usr/lib/libsasl2.so ]; then
  CCARGS="$CCARGS -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl"
  AUXLIBS="$AUXLIBS -lsasl2"
fi
if [ -r /usr/lib/liblmdb.so ]; then
  CCARGS="$CCARGS -DHAS_LMDB"
  AUXLIBS="$AUXLIBS -llmdb"
fi
if [ -r /usr/lib/libldap.so -a -r /usr/lib/liblber.so ]; then
  CCARGS="$CCARGS -DHAS_LDAP"
  AUXLIBS="$AUXLIBS -lldap -llber"
fi
if [ -r /usr/lib/libsqlite3.so ]; then
  CCARGS="$CCARGS -DHAS_SQLITE"
  AUXLIBS="$AUXLIBS -lsqlite3 -lpthread"
fi
if [ -r /usr/lib/libmysqlclient.so ]; then
  CCARGS="$CCARGS -DHAS_MYSQL -I/usr/include/mysql"
  AUXLIBS="$AUXLIBS -lmysqlclient -lz -lm"
fi
if [ -r /usr/lib/libpq.so ]; then
  CCARGS="$CCARGS -DHAS_PGSQL -I/usr/include/postgresql"
  AUXLIBS="$AUXLIBS -lpq -lz -lm"
fi
if [ -r /usr/lib/libssl.so -a -r /usr/lib/libcrypto.so ]; then
  CCARGS="$CCARGS -DUSE_TLS -I/usr/include/openssl/"
  AUXLIBS="$AUXLIBS -lssl -lcrypto"
fi
make CC="gcc -std=gnu17" CCARGS="$CCARGS" AUXLIBS="$AUXLIBS" makefiles
make
/usr/sbin/postfix -c /etc/postfix set-permissions
/usr/sbin/postfix upgrade-configuration
/usr/sbin/postfix check
/usr/sbin/postfix start
groupadd -g 32 postfix
groupadd -g 33 postdrop
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
        -s /bin/false -u 32 postfix
chown -v postfix:postfix /var/mail
sh postfix-install -non-interactive  \
   daemon_directory=/usr/lib/postfix \
   manpage_directory=/usr/share/man  \
   html_directory=/usr/share/doc/postfix-3.10.8/html \
   readme_directory=/usr/share/doc/postfix-3.10.8/readme
cat >> /etc/aliases << "EOF"
# Begin /etc/aliases

MAILER-DAEMON:    postmaster
postmaster:       root

root:             <LOGIN>
# End /etc/aliases
EOF
echo 'default_database_type = lmdb'       >> /etc/postfix/main.cf
echo 'alias_database = lmdb:/etc/aliases' >> /etc/postfix/main.cf
echo 'alias_maps = lmdb:/etc/aliases'     >> /etc/postfix/main.cf
echo 'smtpd_forbid_bare_newline = normalize' >> /etc/postfix/main.cf
echo 'smtpd_forbid_bare_newline_exclusions = $mynetworks' >> /etc/postfix/main.cf


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-postfix
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd