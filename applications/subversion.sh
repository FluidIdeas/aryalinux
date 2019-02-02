#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:apr-util
#REQ:sqlite
#REC:serf

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/subversion/subversion-1.11.1.tar.bz2

NAME=subversion
VERSION=1.11.1
URL=https://archive.apache.org/dist/subversion/subversion-1.11.1.tar.bz2

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

./configure --prefix=/usr \
--disable-static \
--with-apache-libexecdir \
--with-lz4=internal \
--with-utf8proc=internal &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/subversion-1.11.1 &&
cp -v -R doc/* \
/usr/share/doc/subversion-1.11.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
