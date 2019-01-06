#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:aspell
#OPT:cyrus-sasl
#OPT:gdb
#OPT:gnupg
#OPT:gpgme
#OPT:libidn
#OPT:mitkrb
#OPT:mail
#OPT:slang
#OPT:gnutls
#OPT:db
#OPT:libxslt
#OPT:lynx
#OPT:w3m
#OPT:docbook-dsssl
#OPT:openjade
#OPT:texlive
#OPT:tl-installer

cd $SOURCE_DIR

wget -nc http://ftp.mutt.org/pub/mutt/mutt-1.11.0.tar.gz
wget -nc ftp://ftp.mutt.org/pub/mutt/mutt-1.11.0.tar.gz

NAME=mutt
VERSION=1.11.0
URL=http://ftp.mutt.org/pub/mutt/mutt-1.11.0.tar.gz

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
groupadd -g 34 mail
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
chgrp -v mail /var/mail
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cp -v doc/manual.txt{,.shipped} &&
./configure --prefix=/usr                           \
            --sysconfdir=/etc                       \
            --with-docdir=/usr/share/doc/mutt-1.11.0 \
            --with-ssl                              \
            --enable-external-dotlock               \
            --enable-pop                            \
            --enable-imap                           \
            --enable-hcache                         \
            --enable-sidebar                        &&
make &&
make -C doc manual.pdf

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
test -s doc/manual.txt ||
  install -v -m644 doc/manual.txt.shipped \
  /usr/share/doc/mutt-1.11.0/manual.txt
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 doc/manual.pdf \
    /usr/share/doc/mutt-1.11.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

chown root:mail /usr/bin/mutt_dotlock &&
chmod -v 2755 /usr/bin/mutt_dotlock
cat /usr/share/doc/mutt-1.11.0/samples/gpg.rc >> ~/.muttrc

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
