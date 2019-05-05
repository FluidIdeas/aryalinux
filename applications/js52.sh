#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:autoconf213
#REQ:icu
#REQ:nspr
#REQ:python2
#REQ:x7lib
#REQ:zip

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz
wget -nc ftp://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz

NAME=js52
VERSION=52.2.1gnome1
URL=http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz

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

cd js/src &&

CPPFLAGS="-Werror=format-overflow=0" ./configure --prefix=/usr \
--with-intl-api \
--with-system-zlib \
--with-system-nspr \
--with-system-icu \
--enable-readline &&
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
