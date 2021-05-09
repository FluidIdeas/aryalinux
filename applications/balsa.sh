#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:aspell
#REQ:enchant
#REQ:gmime3
#REQ:gpgme
#REQ:gtk3
#REQ:rarian
#REQ:mail
#REQ:pcre


cd $SOURCE_DIR

wget -nc https://pawsa.fedorapeople.org/balsa/balsa-2.6.2.tar.bz2


NAME=balsa
VERSION=2.6.2
URL=https://pawsa.fedorapeople.org/balsa/balsa-2.6.2.tar.bz2
SECTION="Other X-based Programs"
DESCRIPTION="The Balsa package contains a GNOME-2 based mail client."

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


./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --without-html-widget    \
            --without-libnotify      &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

