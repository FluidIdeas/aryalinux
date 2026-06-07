#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:lynx
#REQ:links

cd $SOURCE_DIR
NAME=mutt
VERSION=2.3.0
URL=http://ftp.mutt.org/pub/mutt/mutt-2.3.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc http://ftp.mutt.org/pub/mutt/mutt-2.3.0.tar.gz


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

groupadd -g 34 mail
sed  -e 's/ -with_backspaces//' \
     -e 's/elinks/links/'       \
     -e 's/-no-numbering -no-references//' \
     -i doc/Makefile.in
./configure --prefix=/usr                            \
            --sysconfdir=/etc                        \
            --with-docdir=/usr/share/doc/mutt-2.3.0 \
            --with-ssl                               \
            --enable-external-dotlock                \
            --enable-pop                             \
            --enable-imap                            \
            --enable-hcache                          \
            --enable-sidebar
make
chown root:mail /usr/bin/mutt_dotlock
chmod -v 2755 /usr/bin/mutt_dotlock
cat /usr/share/doc/mutt-2.3.0/samples/gpg.rc >> ~/.muttrc
chgrp -v mail /var/mail


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd