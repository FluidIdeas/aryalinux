#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:apr-util
#REQ:sqlite
#REC:serf

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/subversion/subversion-1.12.0.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/subversion-1.12.0-apr_1.7.0_fix-1.patch

NAME=subversion
VERSION=1.12.0
URL=https://archive.apache.org/dist/subversion/subversion-1.12.0.tar.bz2

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

patch -Np1 -i ../subversion-1.12.0-apr_1.7.0_fix-1.patch
./autogen.sh &&

./configure --prefix=/usr \
--disable-static \
--with-apache-libexecdir \
--with-lz4=internal \
--with-utf8proc=internal &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/subversion-1.12.0 &&
cp -v -R doc/* \
/usr/share/doc/subversion-1.12.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
