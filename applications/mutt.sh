#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://bitbucket.org/mutt/mutt/downloads/mutt-1.12.2.tar.gz
wget -nc ftp://ftp.mutt.org/pub/mutt/mutt-1.12.2.tar.gz


NAME=mutt
VERSION=1.12.2
URL=https://bitbucket.org/mutt/mutt/downloads/mutt-1.12.2.tar.gz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 34 mail
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chgrp -v mail /var/mail
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cp -v doc/manual.txt{,.shipped} &&
./configure --prefix=/usr                           \
            --sysconfdir=/etc                       \
            --with-docdir=/usr/share/doc/mutt-1.12.2 \
            --with-ssl                              \
            --enable-external-dotlock               \
            --enable-pop                            \
            --enable-imap                           \
            --enable-hcache                         \
            --enable-sidebar                        &&
make
make -C doc manual.pdf
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
test -s doc/manual.txt ||
  install -v -m644 doc/manual.txt.shipped \
  /usr/share/doc/mutt-1.12.2/manual.txt
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 doc/manual.pdf \
    /usr/share/doc/mutt-1.12.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

chown root:mail /usr/bin/mutt_dotlock &&
chmod -v 2755 /usr/bin/mutt_dotlock
cat /usr/share/doc/mutt-1.12.2/samples/gpg.rc >> ~/.muttrc


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

