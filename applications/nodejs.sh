#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:python2
#REQ:which
#REC:c-ares
#REC:icu
#REC:libuv

cd $SOURCE_DIR

wget -nc https://nodejs.org/dist/v10.14.2/node-v10.14.2.tar.xz

NAME=nodejs
VERSION=v10.14.2
URL=https://nodejs.org/dist/v10.14.2/node-v10.14.2.tar.xz

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

./configure --prefix=/usr \
--shared-cares \
--shared-libuv \
--shared-openssl \
--shared-zlib \
--with-intl=system-icu &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
ln -sf node /usr/share/doc/node-10.14.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
