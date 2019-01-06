#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:gnutls
#OPT:libxml2
#OPT:mitkrb

cd $SOURCE_DIR

wget -nc https://fossies.org/linux/www/neon-0.30.2.tar.gz

NAME=neon
VERSION=0.30.2
URL=https://fossies.org/linux/www/neon-0.30.2.tar.gz

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

sed -e 's/client_set/set/'  \
    -e 's/gnutls_retr/&2/'  \
    -e 's/type = t/cert_&/' \
    -i src/ne_gnutls.c
./configure --prefix=/usr    \
            --with-ssl       \
            --enable-shared  \
            --disable-static &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
