#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python2
#REQ:which
#REQ:c-ares
#REQ:icu
#REQ:libuv
#REQ:nghttp2


cd $SOURCE_DIR

wget -nc https://nodejs.org/dist/v10.16.1/node-v10.16.1.tar.xz


NAME=nodejs
VERSION=10.16.1
URL=https://nodejs.org/dist/v10.16.1/node-v10.16.1.tar.xz

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


./configure --prefix=/usr                  \
            --shared-cares                 \
            --shared-libuv                 \
            --shared-nghttp2               \
            --shared-openssl               \
            --shared-zlib                  \
            --with-intl=system-icu         &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -sf node /usr/share/doc/node-10.16.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

